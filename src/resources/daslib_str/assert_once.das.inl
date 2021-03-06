//
// AUTO-GENERATED FILE - DO NOT EDIT!!
//

"options indenting = 4\n"
"options no_unused_block_arguments = false\n"
"options no_unused_function_arguments = false\n"
"options no_aot = true\n"
"\n"
"module assert_once shared private\n"
"\n"
"require ast\n"
"require rtti\n"
"require daslib/ast_boost\n"
"require daslib/templates_boost\n"
"\n"
"[tag_function(asset_once_tag)]\n"
"def public assert_once ( expr:bool; message:string=\"\" ) {}\n"
"\n"
"// convert assert_once(expr,message) to\n"
"//  var\n"
"//      __assert_once_I = true\n"
"//  if __assert_once_I && !expr\n"
"//      __assert_once_I = false\n"
"//      assert(false,message)\n"
"[tag_function_macro(tag=\"asset_once_tag\")]\n"
"class AssertOnceMacro : AstFunctionAnnotation\n"
"    def override transform ( var call : smart_ptr<ExprCallFunc>; var errors : da"
"s_string ) : ExpressionPtr\n"
"        var once_name = make_unique_private_name(\"__assert_once\",call.at)\n"
"        if !compiling_module() |> add_global_private_var(once_name, call.at) <| "
"quote(true)\n"
"            errors := \"can't add global variable {once_name}\"\n"
"            return [[ExpressionPtr]]\n"
"        // if ..\n"
"        var qblock <- quote() <|\n"
"            if __assert_once_I && !expr\n"
"                __assert_once_I = false\n"
"                assert(false, message)\n"
"        // rename\n"
"        apply_template(call.at, qblock) <| $ ( rules )\n"
"            rules |> renameVariable(\"__assert_once_I\") <| once_name\n"
"            rules |> replaceVariable(\"expr\") <| clone_expression(call.arguments["
"0])\n"
"            rules |> replaceVariable(\"message\") <| clone_expression(call.argumen"
"ts[1])\n"
"        return move_unquote_block(qblock)\n"
