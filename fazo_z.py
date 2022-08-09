import os
import re

ROOT_PATH = "./lib/"


class Table:
    def __init__(self, sql, table_name):
        self.sql = sql
        self.table_name = table_name
        self.columns = []
        self.constraints = []

    def append_column(self, column):
        if not isinstance(column, Column):
            raise Exception("column parameter is not type Column type")
        self.columns.append(column)

    def set_constraints(self, items):
        self.constraints = items

    def get_name2class(self):
        return "".join([x[0].upper() + x[1:] for x in self.table_name.split("_")])

    def get_name_without_prefix(self):
        return self.table_name[self.table_name.index("_") + 1:].strip()

    def has_columns(self):
        return len(self.columns) > 0

    def get_primary_columns(self):
        primary_key = [x for x in self.constraints if x.startswith("primary key")]
        if len(primary_key) == 1:
            pk = primary_key[0].replace("primary key", "").strip()
            column_names = [x.strip() for x in pk[pk.index("(") + 1:pk.index(")")].split(",")]
            return [x for x in self.columns if x.name in column_names]
        elif len(primary_key) > 1:
            raise Exception(f"{self.get_name2class()} primary key more than one {primary_key}")
        else:
            return []

    def __str__(self):
        columns = "\n".join([str(x) for x in self.columns])
        return f"Table:{self.table_name}\n{columns}"


class Column:
    def __init__(self, name, column_type, is_required):
        self.name = name
        self.column_type = column_type
        self.is_required = is_required

    def get_name2constant(self):
        return f"C_{self.name.upper()}"

    def get_type_object(self):
        if "text" == self.column_type:
            return "String"
        elif "int" == self.column_type or "integer" == self.column_type:
            return "int"
        elif "blob" == self.column_type:
            return "Uint8List"
        elif "real" == self.column_type:
            return "num"
        else:
            raise Exception(f"{self.column_type} type is not recognized")

    def is_str(self):
        return "text" == self.column_type

    def is_blob(self):
        return "blob" == self.column_type

    def get_name2class(self):
        return "".join(
            [f"{x[0].upper() if index > 0 else x[0]}{x[1:]}" for index, x in
             enumerate(self.name.split("_"))])

    def __str__(self):
        return f"name:{self.name}, type:{self.column_type}"


# ----------------------------------------------------------------------------------------------------------------------

class GenerateZ:
    def __init__(self, buffer: list, table: Table):
        self.buffer = buffer
        self.table = table

    def __gen_check_primary_name2class(self, prefix=""):
        b = self.buffer
        t = self.table
        pk_columns = t.get_primary_columns()
        checks = [f"{prefix}{c.get_name2class()}".strip() for c in pk_columns]
        if len(checks) > 0:
            checks = ", ".join(checks)
            b.append(f"\t\t{t.get_name2class()}.checkPrimaryKeys({checks});")

    def __gen_check_required_name2class(self, prefix=""):
        b = self.buffer
        t = self.table
        checks = [f"{prefix}{c.get_name2class()}".strip()
                  for c in t.columns if c.is_required]
        if len(checks) > 0:
            checks = ", ".join(checks)
            b.append(f"\t\t{t.get_name2class()}.checkRequired({checks});")

    def __init(self):
        b = self.buffer
        t = self.table

        req_ann = "@required "
        emp_str = ""
        columns = [
            f"{req_ann if c.is_required else emp_str}{c.get_type_object()} {c.get_name2class()}"
            for c in t.columns]
        b.append("\t// init")
        b.append("\tstatic " + t.get_name2class() + " init({" + ", ".join(columns) + "}) {")
        self.__gen_check_primary_name2class()

        args = ", ".join([f"{c.get_name2class()}: {c.get_name2class()}" for c in t.columns])
        b.append(f"\t\treturn new {t.get_name2class()}({args});")
        b.append("\t}")

    def __load_all(self):
        b = self.buffer
        t = self.table
        b.append("\t// load all rows in database")
        b.append("\tstatic Future<List<" + t.get_name2class() + ">> loadAll(Database db) {")
        b.append(f"\t\treturn db.query({t.get_name2class()}.TABLE_NAME)")
        b.append(f"\t\t\t.then((it) => it.map((d) => {t.get_name2class()}.fromData(d)).toList());")
        b.append("\t}")

    def __take(self):
        b = self.buffer
        t = self.table

        pk_columns = t.get_primary_columns()
        if len(pk_columns) == 0:
            return
        b.append("")

        pk = [f"{c.get_type_object()} {c.get_name2class()}" for c in pk_columns]

        b.append("\t// take row in database if no_data_found return null")
        args = ", ".join(pk)
        b.append(
            f"\tstatic Future<{t.get_name2class()}> take(Database db, {args}) async " + "{")
        self.__gen_check_primary_name2class()
        where_pk = ["${" + t.get_name2class() + "." + x.get_name2constant() + "} = ?" for x in
                    pk_columns]
        where_pk = " AND ".join(where_pk)
        where_args = [x.get_name2class() for x in pk_columns]
        where_args = ", ".join(where_args)
        b.append("\t\tfinal result = await db"
                 ".query(" + t.get_name2class() + ".TABLE_NAME, where: \"" + where_pk + "\", whereArgs: [" + where_args + "]);")
        b.append(f"\t\treturn result.isEmpty ? null : {t.get_name2class()}.fromData(result.first);")
        b.append("\t}")

    def __load(self):
        b = self.buffer
        t = self.table

        pk_columns = t.get_primary_columns()
        if len(pk_columns) == 0:
            return
        b.append("")
        pk = [f"{c.get_type_object()} {c.get_name2class()}" for c in pk_columns]

        b.append("\t// load row in database if no_data_found throw exception")
        args = ", ".join(pk)
        b.append(f"\tstatic Future<{t.get_name2class()}> load(Database db, {args}) async " + "{")
        self.__gen_check_primary_name2class()
        args = ", ".join([x.get_name2class() for x in pk_columns])
        b.append(f"\t\tfinal result = await take(db, {args});")
        b.append("\t\tif (result == null) {")
        b.append("\t\t\tthrow Exception(\"no data found\");")
        b.append("\t\t}")
        b.append("\t\treturn result;")
        b.append("\t}")

    def __exist(self):
        b = self.buffer
        t = self.table

        pk_columns = t.get_primary_columns()
        if len(pk_columns) == 0:
            return
        b.append("")
        pk = [f"{c.get_type_object()} {c.get_name2class()}" for c in pk_columns]

        b.append("\t// check exist row in database return boolean if exists true or else")
        b.append("\tstatic Future<bool> exist(Database db, " + ", ".join(pk) + ") {")
        self.__gen_check_primary_name2class()
        args = [x.get_name2class() for x in pk_columns]
        b.append("\t\treturn take(db, " + ", ".join(args) + ").then((it) => it != null);")
        b.append("\t}")

    def __exist_take(self):
        b = self.buffer
        t = self.table
        pk_columns = t.get_primary_columns()
        if len(pk_columns) == 0:
            return
        b.append("")
        pk = [f"{c.get_type_object()} {c.get_name2class()}" for c in pk_columns]

        b.append("\t// check exist row in database and getting result")
        b.append("\tstatic Future<bool> existTake(Database db, " + ", ".join(
            pk) + ", void onResult(" + t.get_name2class() + " row)) async {")
        self.__gen_check_primary_name2class()
        b.append("\t\tArgumentError.checkNotNull(onResult, \"OnResult\");")
        args = [x.get_name2class() for x in pk_columns]
        b.append("\t\tfinal result = await take(db, " + ", ".join(args) + ");")
        b.append("\t\tonResult.call(result);")
        b.append("\t\treturn result != null;")
        b.append("\t}")

    def __update_row(self):
        b = self.buffer
        t = self.table

        pk_columns = t.get_primary_columns()
        if len(pk_columns) == 0:
            return
        b.append("")

        b.append("\t// update row")
        b.append(
            "\tstatic Future<int> updateRow(dynamic db, " + t.get_name2class() + " row, {bool removeNull = false}) {")
        self.__gen_check_primary_name2class(prefix="row.")
        where_pk = ["${" + t.get_name2class() + "." + x.get_name2constant() + "} = ?" for x in
                    pk_columns]
        where_pk = " AND ".join(where_pk)
        where_args = [f"row.{x.get_name2class()}" for x in pk_columns]
        where_args = ", ".join(where_args)
        b.append("\t\tfinal data = row.toData();")
        b.append("\t\tif (removeNull) {")
        b.append("\t\t\tdata.removeWhere((key, value) => value == null);")
        b.append("\t\t}")
        b.append("\t\tif (db is Batch) {")
        b.append("\t\t\tdb.update(" + t.get_name2class() +
                 ".TABLE_NAME, data, where: \"" + where_pk + "\", whereArgs: [" + where_args + "]);")
        b.append("\t\t\treturn Future.value(-1);")
        b.append("\t\t}")
        b.append("\t\telse if (db is Database) {")
        b.append("\t\t\treturn db.update(" + t.get_name2class() +
                 ".TABLE_NAME, data, where: \"" + where_pk + "\", whereArgs: [" + where_args + "]);")
        b.append("\t\t}")
        b.append("\t\telse{")
        b.append("\t\t\tthrow Exception(\"db object must be instance of Database or Batch\");")
        b.append("\t\t}")
        b.append("\t}")

    def __update_one(self):
        b = self.buffer
        t = self.table

        pk_columns = t.get_primary_columns()
        if len(pk_columns) == 0:
            return
        b.append("")

        pk_names = [x.name for x in pk_columns]
        req_ann = "@required "
        emp_str = ""
        method_params = [
            f"{req_ann if c.name in pk_names else emp_str}{c.get_type_object()} {c.get_name2class()}"
            for c in t.columns]
        b.append("\t// update by one")
        b.append(
            "\tstatic Future<int> updateOne(dynamic db, {" + ", ".join(
                method_params) + ", bool removeNull = false}) {")
        self.__gen_check_primary_name2class()
        args = ", ".join([x.get_name2class() for x in t.columns])
        b.append(
            "\t\treturn updateRow(db, toRowFromList(values: [" + args + "]), removeNull: removeNull);")
        b.append("\t}")

    def __save_row(self):
        b = self.buffer
        t = self.table

        b.append("\t// save row")
        b.append(
            "\tstatic Future<int> saveRow(dynamic db, " + t.get_name2class() + " row, {bool removeNull = false}) {")
        self.__gen_check_primary_name2class(prefix="row.")
        b.append("\t\tfinal data = row.toData();")
        b.append("\t\tif (removeNull) {")
        b.append("\t\t\tdata.removeWhere((key, value) => value == null);")
        b.append("\t\t}")
        b.append("\t\tif (db is Batch) {")
        b.append("\t\t\tdb.insert(" + t.get_name2class() +
                 ".TABLE_NAME, data, conflictAlgorithm: ConflictAlgorithm.replace);")
        b.append("\t\t\treturn Future.value(-1);")
        b.append("\t\t}")
        b.append("\t\telse if (db is Database) {")
        b.append(
            "\t\t\treturn db.insert(" + t.get_name2class() + ".TABLE_NAME, data, conflictAlgorithm: ConflictAlgorithm.replace);")
        b.append("\t\t}")
        b.append("\t\telse{")
        b.append("\t\t\tthrow Exception(\"db object must be instance of Database or Batch\");")
        b.append("\t\t}")
        b.append("\t}")

    def __save_one(self):
        b = self.buffer
        t = self.table

        req_ann = "@required "
        emp_str = ""
        method_params = [
            f"{req_ann if c.is_required else emp_str}{c.get_type_object()} {c.get_name2class()}"
            for c in t.columns]
        b.append("\t// save one")
        b.append("\tstatic Future<int> saveOne(dynamic db, {" + ", ".join(
            method_params) + ", bool removeNull = false}) {")
        self.__gen_check_primary_name2class()
        args = ", ".join([x.get_name2class() for x in t.columns])
        b.append(
            "\t\treturn saveRow(db, toRowFromList(values: [" + args + "]), removeNull: removeNull);")
        b.append("\t}")

    def __delete_all(self):
        b = self.buffer
        t = self.table

        b.append("\t// delete all rows in database")
        b.append("\tstatic Future<int> deleteAll(dynamic db) {")
        b.append("\t\tif (db is Batch) {")
        b.append("\t\t\tdb.delete(" + t.get_name2class() + ".TABLE_NAME);")
        b.append("\t\t\treturn Future.value(-1);")
        b.append("\t\t}")
        b.append("\t\telse if (db is Database) {")
        b.append("\t\t\treturn db.delete(" + t.get_name2class() + ".TABLE_NAME);")
        b.append("\t\t}")
        b.append("\t\telse{")
        b.append("\t\t\tthrow Exception(\"db object must be instance of Database or Batch\");")
        b.append("\t\t}")
        b.append("\t}")

    def __delete_one(self):
        b = self.buffer
        t = self.table

        pk_columns = t.get_primary_columns()
        if len(pk_columns) == 0:
            return
        b.append("")

        method_params = [f"{c.get_type_object()} {c.get_name2class()}" for c in pk_columns]
        b.append("\t// delete row by primary key")
        b.append("\tstatic Future<int> deleteOne(dynamic db, " + ", ".join(method_params) + ") {")
        self.__gen_check_primary_name2class()
        where_pk = ["${" + t.get_name2class() + "." + x.get_name2constant() + "} = ?" for x in
                    pk_columns]
        where_pk = " AND ".join(where_pk)
        where_args = [f"{x.get_name2class()}" for x in pk_columns]
        where_args = ", ".join(where_args)
        b.append("\t\tif (db is Batch) {")
        b.append("\t\t\t db.delete(" + t.get_name2class() +
                 ".TABLE_NAME, where: \"" + where_pk + "\", whereArgs: [" + where_args + "]);")
        b.append("\t\t\treturn Future.value(-1);")
        b.append("\t\t}")
        b.append("\t\telse if (db is Database) {")
        b.append("\t\t\treturn db.delete(" + t.get_name2class() +
                 ".TABLE_NAME, where: \"" + where_pk + "\", whereArgs: [" + where_args + "]);")
        b.append("\t\t}")
        b.append("\t\telse{")
        b.append("\t\t\tthrow Exception(\"db object must be instance of Database or Batch\");")
        b.append("\t\t}")
        b.append("\t}")

    def __insert_row_try(self):
        b = self.buffer
        t = self.table

        b.append("\t// insert row try insert if exists abort")
        b.append("\tstatic Future<int> insertRowTry(dynamic db, " + t.get_name2class() + " row) {")
        self.__gen_check_required_name2class(prefix="row.")
        b.append("\t\tif (db is Batch) {")
        b.append(
            "\t\t\tdb.insert(" + t.get_name2class() + ".TABLE_NAME, row.toData(), conflictAlgorithm: ConflictAlgorithm.abort);")
        b.append("\t\t\treturn Future.value(-1);")
        b.append("\t\t}")
        b.append("\t\telse if (db is Database) {")
        b.append(
            "\t\t\treturn db.insert(" + t.get_name2class() + ".TABLE_NAME, row.toData(), conflictAlgorithm: ConflictAlgorithm.abort);")
        b.append("\t\t}")
        b.append("\t\telse{")
        b.append("\t\t\tthrow Exception(\"db object must be instance of Database or Batch\");")
        b.append("\t\t}")
        b.append("\t}")

    def __insert_one_try(self):
        b = self.buffer
        t = self.table

        req_ann = "@required "
        emp_str = ""
        method_params = [
            f"{req_ann if c.is_required else emp_str}{c.get_type_object()} {c.get_name2class()}"
            for c in t.columns]

        b.append(
            "\tstatic Future<int> insertOneTry(dynamic db, {" + ", ".join(method_params) + "}) {")
        self.__gen_check_required_name2class()
        args = ", ".join([c.get_name2class() for c in t.columns])
        b.append("\t\treturn insertRowTry(db, toRowFromList(values: [" + args + "]));")
        b.append("\t}")

    def __insert_row(self):
        b = self.buffer
        t = self.table

        b.append("\t// insert row if exists fail")
        b.append("\tstatic Future<int> insertRow(dynamic db, " + t.get_name2class() + " row) {")
        self.__gen_check_required_name2class(prefix="row.")

        b.append("\t\tif (db is Batch) {")
        b.append(
            "\t\t\tdb.insert(" + t.get_name2class() + ".TABLE_NAME, row.toData(), conflictAlgorithm: ConflictAlgorithm.fail);")
        b.append("\t\t\treturn Future.value(-1);")
        b.append("\t\t}")
        b.append("\t\telse if (db is Database) {")
        b.append(
            "\t\t\treturn db.insert(" + t.get_name2class() + ".TABLE_NAME, row.toData(), conflictAlgorithm: ConflictAlgorithm.fail);")
        b.append("\t\t}")
        b.append("\t\telse{")
        b.append("\t\t\tthrow Exception(\"db object must be instance of Database or Batch\");")
        b.append("\t\t}")
        b.append("\t}")

    def __insert_one(self):
        b = self.buffer
        t = self.table

        req_ann = "@required "
        emp_str = ""
        method_params = [
            f"{req_ann if c.is_required else emp_str}{c.get_type_object()} {c.get_name2class()}"
            for c in t.columns]

        b.append(
            "\tstatic Future<int> insertOne(dynamic db, {" + ", ".join(method_params) + "}) {")
        self.__gen_check_required_name2class()
        args = ", ".join([c.get_name2class() for c in t.columns])
        b.append("\t\treturn insertRow(db, toRowFromList(values: [" + args + "]));")
        b.append("\t}")

    def __to_map(self):
        b = self.buffer
        t = self.table

        b.append("\t// to map")
        method_keys = ", ".join(["String f" + str(i + 1) for i, _ in enumerate(t.columns)])
        method_params = ", ".join(
            [f"{c.get_type_object()} {c.get_name2class()}" for c in t.columns])
        b.append("\tstatic Map<String, dynamic> toMap({" + t.get_name2class() +
                 " row, " + method_keys + ", " + method_params + "}) {")
        value_nvls = [
            f"\t\t{c.get_name2class()} = nvl(row?.{c.get_name2class()}, {c.get_name2class()});"
            for c in t.columns]
        b.append("\n".join(value_nvls))
        self.__gen_check_required_name2class()
        args = [
            f"nvlString(f{i + 1}, {t.get_name2class()}.{c.get_name2constant()}): {c.get_name2class()}"
            for i, c in enumerate(t.columns)]
        b.append("\t\treturn {" + ", ".join(args) + "};")
        b.append("\t}")

    def __to_list(self):
        b = self.buffer
        t = self.table

        b.append("\t// to list")
        method_params = ", ".join(
            [f"{c.get_type_object()} {c.get_name2class()}" for c in t.columns])
        b.append("\tstatic List<dynamic> toList({" +
                 t.get_name2class() + " row, " + method_params + "}) {")
        value_nvls = [
            f"\t\t{c.get_name2class()} = nvl(row?.{c.get_name2class()}, {c.get_name2class()});"
            for c in t.columns]
        b.append("\n".join(value_nvls))
        self.__gen_check_required_name2class()
        args = [c.get_name2class() for c in t.columns]
        b.append("\t\treturn [" + ", ".join(args) + "];")
        b.append("\t}")

    def __to_row_from_map(self):
        b = self.buffer
        t = self.table

        b.append("\t// to row from map")
        method_keys = ", ".join(["String f" + str(i + 1) for i, _ in enumerate(t.columns)])
        method_params = ", ".join(
            [f"{c.get_type_object()} {c.get_name2class()}" for c in t.columns])
        b.append(
            "\tstatic " + t.get_name2class() + " toRowFromMap({Map<String, dynamic> data, " + method_keys + ", " + method_params + "}) {")
        nvls = [
            f"\t\t{c.get_name2class()} = nvl(data == null ? null : data[nvl(f{i + 1}, {t.get_name2class()}.{c.get_name2constant()})], {c.get_name2class()});"
            for i, c in enumerate(t.columns)]
        b.append("\n".join(nvls))
        self.__gen_check_primary_name2class()
        args = ", ".join([f"{c.get_name2class()}: {c.get_name2class()}" for c in t.columns])
        b.append(f"\t\treturn new {t.get_name2class()}({args});")
        b.append("\t}")

    def __to_row_from_list(self):
        b = self.buffer
        t = self.table

        b.append("\t// to row from list")
        method_keys = ", ".join(["String f" + str(i + 1) for i, _ in enumerate(t.columns)])
        b.append(
            "\tstatic " + t.get_name2class() + " toRowFromList({@required List<dynamic> values, List<String> keys, " + method_keys + "}) {")
        values = [
            f"\t\tfinal {c.get_name2class()} = values[keys?.indexOf(nvl(f{i + 1}, {t.get_name2class()}.{c.get_name2constant()})) ?? {i}];"
            for i, c in enumerate(t.columns)]
        b.append("\n".join(values))
        self.__gen_check_primary_name2class()
        args = ", ".join([f"{c.get_name2class()}: {c.get_name2class()}" for c in t.columns])
        b.append(f"\t\treturn new {t.get_name2class()}({args});")
        b.append("\t}")

    def __to_row_from_list_string(self):
        b = self.buffer
        t = self.table

        b.append("\t// to row from list strings")
        method_keys = ", ".join(["String f" + str(i + 1) for i, _ in enumerate(t.columns)])
        b.append(
            "\tstatic " + t.get_name2class() + " toRowFromListString({@required List<String> values, List<String> keys, " + method_keys + "}) {")
        values = [
            f"\t\tdynamic {c.get_name2class()} = values[keys?.indexOf(nvl(f{i + 1}, {t.get_name2class()}.{c.get_name2constant()})) ?? {i}];"
            for i, c in enumerate(t.columns)]
        b.append("\n".join(values))

        values = [
            f"\t\t{c.get_name2class()} = {c.get_name2class()} is String && {c.get_name2class()}.isNotEmpty ? num.parse({c.get_name2class()}) : null;"
            for c in t.columns if not c.is_str()]
        b.append("\n".join(values))

        self.__gen_check_primary_name2class()
        args = ", ".join([f"{c.get_name2class()}: {c.get_name2class()}" for c in t.columns])
        b.append(f"\t\treturn new {t.get_name2class()}({args});")
        b.append("\t}")

    def run(self):
        b = self.buffer
        t = self.table

        b.append("// Database table common functions")
        b.append("// ignore: camel_case_types")

        cls_name = "Z_{}".format(t.get_name2class())
        b.append(f"class {cls_name}" + " {")

        b.append("")
        self.__init()

        b.append("")
        self.__load_all()

        self.__take()

        self.__load()

        self.__exist()

        self.__exist_take()

        self.__update_row()

        self.__update_one()

        b.append("")
        self.__save_row()

        b.append("")
        self.__save_one()

        b.append("")
        self.__delete_all()

        self.__delete_one()

        b.append("")
        self.__insert_row_try()

        b.append("")
        self.__insert_one_try()

        b.append("")
        self.__insert_row()

        b.append("")
        self.__insert_one()

        b.append("")
        self.__to_map()

        b.append("")
        self.__to_list()

        b.append("")
        self.__to_row_from_map()

        b.append("")
        self.__to_row_from_list()

        b.append("")
        self.__to_row_from_list_string()

        b.append("")
        b.append("\tstatic R nvl<R>(R a, R b) {")
        b.append("\t\treturn a == null ? b : a;")
        b.append("\t}")

        b.append("")
        b.append("\tstatic String nvlString(String a, String b) {")
        b.append("\t\treturn a == null || a.isEmpty ? b : a;")
        b.append("\t}")

        b.append("}")
        b.append("")


# ----------------------------------------------------------------------------------------------------------------------

def generate_table_class(buffer: list, table: Table):
    # Generate class
    buffer.append("// Database table object information")
    buffer.append(f"class {table.get_name2class()} " + "{")

    pk_columns = table.get_primary_columns()

    buffer.append("\t// ignore: non_constant_identifier_names")
    buffer.append(f"\tstatic const String TABLE_NAME = \"{table.table_name}\";")
    for c in table.columns:
        buffer.append("\t// ignore: non_constant_identifier_names")
        buffer.append(f"\tstatic const String {c.get_name2constant()} = \"{c.name}\";")

    buffer.append("")
    buffer.append(
        "\t//------------------------------------------------------------------------------------------------")
    buffer.append("")
    buffer.append("\t// ignore: non_constant_identifier_names")
    buffer.append("\tstatic final String TABLE = \"\"\"")
    buffer.append("\t" + table.sql.replace("\n", "\n\t"))
    buffer.append("\t\"\"\";")
    buffer.append("")
    buffer.append(
        "\t//------------------------------------------------------------------------------------------------")

    # check requires
    buffer.append("")
    method_params = [f"{x.get_type_object()} {x.get_name2class()}" for x in table.columns if
                     x.is_required]
    buffer.append("\tstatic void checkRequired(" + ", ".join(method_params) + ") {")
    checks = [f"\t\tArgumentError.checkNotNull({x.get_name2class()}, {x.get_name2constant()});"
              for x in table.columns if x.is_required]
    buffer.append("\n".join(checks))
    buffer.append("\t}")

    method_params = [f"{x.get_type_object()} {x.get_name2class()}" for x in pk_columns]
    if len(method_params) > 0:
        # check primary keys
        buffer.append("")
        buffer.append("\tstatic void checkPrimaryKeys(" + ", ".join(method_params) + ") {")
        checks = [f"\t\tArgumentError.checkNotNull({x.get_name2class()}, {x.get_name2constant()});"
                  for x in pk_columns]
        buffer.append("\n".join(checks))
        buffer.append("\t}")
        buffer.append("")
        buffer.append(
            "\t//------------------------------------------------------------------------------------------------")

    buffer.append("")
    for c in table.columns:
        buffer.append(f"\tfinal {c.get_type_object()} {c.get_name2class()};")

    # Constructor
    annotation_required = "@required "
    empty_str = ""
    constructor_params = [
        f"{annotation_required if x.is_required else empty_str}this.{x.get_name2class()}"
        for x in table.columns]
    constructor_params = "{" + ", ".join(constructor_params) + "}"

    args = ", ".join([x.get_name2class() for x in pk_columns])
    buffer.append("")
    buffer.append(
        f"\t{table.get_name2class()}({constructor_params})" + (" {" if len(args) > 0 else ";"))

    if len(args.strip()) > 0:
        buffer.append(f"\t\tcheckPrimaryKeys({args});")
        buffer.append("\t}")

    # fromData
    buffer.append("")
    buffer.append(
        "\tfactory {}.fromData(Map<String, dynamic> data)".format(table.get_name2class()) + " {")
    args = ", ".join([f"data[{x.get_name2constant()}]" for x in pk_columns])
    if len(args.strip()) > 0:
        buffer.append(f"\t\tcheckPrimaryKeys({args});")
    buffer.append(f"\t\treturn {table.get_name2class()}(")
    params = [f"\t\t\t{x.get_name2class()}: data[{x.get_name2constant()}]," for x in table.columns]
    buffer.append("\n".join(params))
    buffer.append("\t\t);")
    buffer.append("\t}")
    buffer.append("")

    # toData
    buffer.append("\tMap<String, dynamic> toData() {")
    buffer.append("\t\treturn {")
    maps = [f"\t\t\t{x.get_name2constant()}: this.{x.get_name2class()}," for x in table.columns]
    buffer.append("\n".join(maps))
    buffer.append("\t\t};")
    buffer.append("\t}")
    buffer.append("")

    # toString
    buffer.append("\t@override")
    buffer.append("\tString toString() {")
    values = ", ".join([f"${x.get_name2constant()}:${x.get_name2class()}" for x in table.columns])
    buffer.append(f"\t\t return \"{table.get_name2class()}({values})\";")
    buffer.append("\t}")

    # End class
    buffer.append("}")
    buffer.append("")


def generate_class(path: str, table: Table):
    buffer = []

    has_bytes = [x for x in table.columns if x.is_blob()]

    buffer.append("// WARNING: THIS FILE IS GENERATE AUTOMATICALLY")
    buffer.append("// NOT EDIT THIS FILE BY HAND")
    if len(has_bytes) > 0:
        buffer.append("import 'dart:typed_data';")
        buffer.append("")
    buffer.append("import 'package:meta/meta.dart';")
    buffer.append("import 'package:sqflite/sqflite.dart';")
    buffer.append("")

    # Generate table class
    generate_table_class(buffer, table)

    # Generate table z common functions
    GenerateZ(buffer=buffer, table=table).run()

    main_path = f"{path}"
    if not os.path.exists(main_path):
        os.makedirs(main_path)

    with open(main_path + f"{table.get_name_without_prefix()}.dart", 'wt') as output:
        output.write("\n".join(buffer))


# ----------------------------------------------------------------------------------------------------------------------

def get_table_columns(table_body):
    columns = []
    body = table_body
    while not body.startswith('constraint'):
        item = body[:body.index(",")] if body.__contains__(",") else body.strip()
        if len(item) == 0 or item.startswith("constraint"):
            break
        columns.append(item)
        if len(body.strip()) > 0 and body.__contains__(","):
            body = body[body.index(",") + 1:]
        else:
            break

    constraint_list = []
    body = table_body
    while len(body.strip()) > 0:
        if body.startswith("constraint"):
            if body.__contains__("),"):
                item = body[:body.index("),") + 1].replace("constraint ", "").strip()
                item = item[item.index(" "):].strip()
                constraint_list.append(item)
            else:
                item = body.replace("constraint ", "")
                item = item[item.index(" "):].strip()
                constraint_list.append(item)
                break
            body = body[body.index("),") + 1:]
        else:
            if body.__contains__(","):
                body = body[body.index(",") + 1:]
            else:
                break

    return columns, constraint_list


def table(path: str, table_sql: str, buffer):
    buffer = buffer.replace("if not exists", "").strip()

    table_name = buffer[:buffer.index("(")].strip()
    table_info = Table(table_sql, table_name)

    (t_columns, t_constraint) = get_table_columns(buffer[buffer.index("("):][1:-1].strip())
    table_info.set_constraints(t_constraint)

    for c in t_columns:
        column_splits = c.split(" ")
        column_name = column_splits[0].strip()
        column_type = column_splits[1].strip()
        is_required = False

        if len(column_splits) > 2:
            if column_splits[2] == "not" \
                    and len(column_splits) > 3 \
                    and column_splits[3] == "null":
                is_required = True

        table_info.append_column(Column(column_name, column_type, is_required))

    if table_info.has_columns():
        generate_class(path, table_info)
    else:
        print(f"Table \"{table_info.table_name}\" no column found")


def create(path, table_sql, buffer):
    # print("")
    # print(table_sql)

    if buffer.startswith("table"):
        table(path, table_sql, buffer[len("table"):].strip())


def read_file(path: str, file_name: str):
    with open(path + file_name, 'rt') as input:
        original_list = input.readlines()
        original_list = [x.replace('-' * 100, "") for x in original_list]
        original_list = [x[:x.index('--')] if x.__contains__('--') else x for x in original_list]
        original_list = [x if x.endswith("\n") else f"{x}\n"
                         for x in original_list if len(x.strip()) > 0]
        list_buffer = [re.sub(' +', ' ', x.strip()).lower() for x in original_list]
    return ["".join(original_list), "".join(list_buffer)]


def run(path):
    for file_name in [x for x in os.listdir(path)]:
        if not os.path.isfile('/'.join([path, file_name])):
            run(f'{path}{file_name}/')
            continue
        if file_name.endswith(".sqflite"):
            print(f"start generate {file_name} file")
            buffer = read_file(path, file_name)

            original_tables = buffer[0].split(";")
            for index, r in enumerate(buffer[1].split(";")):
                if r.startswith("create"):
                    create(path, f"{original_tables[index].strip()};", r[len("create"):].strip())


if __name__ == "__main__":
    run(ROOT_PATH)
