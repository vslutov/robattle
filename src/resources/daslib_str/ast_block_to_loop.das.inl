//
// AUTO-GENERATED FILE - DO NOT EDIT!!
//

"options indenting = 4\n"
"options no_unused_block_arguments = false\n"
"options no_unused_function_arguments = false\n"
"options no_aot = true\n"
"\n"
"module ast_block_to_loop shared public\n"
"\n"
"require daslib/ast_boost\n"
"\n"
"class B2LVisitor : AstVisitor\n"
"    inClosure : int\n"
"    inArchetype : int\n"
"    failOnReturn : bool\n"
"    replaceReturnWithContinue : bool\n"
"    requireContinueCond : bool\n"
"    loop_depth : array<int>\n"
"    def B2LVisitor(fOnR,rRetWC,rCC:bool)\n"
"        failOnReturn = fOnR\n"
"        replaceReturnWithContinue = rRetWC\n"
"        requireContinueCond = rCC\n"
"        loop_depth |> push(0)\n"
"    def override visitExprReturn(expr:smart_ptr<ExprReturn>) : ExpressionPtr\n"
"        if inClosure==0 && inArchetype==0\n"
"            if failOnReturn\n"
"                return make_static_assert_false(\"return is not allowed inside th"
"is macros's block\", expr.at)\n"
"            elif replaceReturnWithContinue\n"
"                if expr.subexpr != null\n"
"                    return  <- new [[ExprIfThenElse() at=expr.at,\n"
"                        cond <- clone_expression(expr.subexpr),\n"
"                        if_true <- new [[ExprReturn() at=expr.at,\n"
"                                subexpr <- new [[ExprConstBool() at=expr.at, val"
"ue:=true]]\n"
"                            ]],\n"
"                        if_false <- new [[ExprContinue() at=expr.at]]\n"
"                    ]]\n"
"                else\n"
"                    if requireContinueCond\n"
"                        macro_error(compiling_program(),expr.at,\"expecting retur"
"n boolean (continue or stop)\")\n"
"                    else\n"
"                        return <- new [[ExprContinue() at=expr.at]]\n"
"        return expr\n"
"    def override preVisitExprFor(expr:smart_ptr<ExprFor>) : void\n"
"        loop_depth |> back ++\n"
"    def override visitExprFor(expr:smart_ptr<ExprFor>) : ExpressionPtr\n"
"        loop_depth |> back --\n"
"        return expr\n"
"    def override preVisitExprWhile(expr:smart_ptr<ExprWhile>) : void\n"
"        loop_depth |> back ++\n"
"    def override visitExprWhile(expr:smart_ptr<ExprWhile>) : ExpressionPtr\n"
"        loop_depth |> back --\n"
"        return expr\n"
"    def override preVisitExprBlock(blk:smart_ptr<ExprBlock>) : void\n"
"        if blk.blockFlags.isClosure\n"
"            inClosure ++\n"
"            loop_depth |> push(0)\n"
"    def override visitExprBlock(blk:smart_ptr<ExprBlock>) : ExpressionPtr\n"
"        if blk.blockFlags.isClosure\n"
"            inClosure --\n"
"            loop_depth |> pop()\n"
"        return blk\n"
"    def override preVisitExprCall(expr:smart_ptr<ExprCall>): void\n"
"        if expr.name==\"for_each_archetype\"\n"
"            inArchetype ++\n"
"            loop_depth |> push(0)\n"
"    def override visitExprCall(expr:smart_ptr<ExprCall>) : ExpressionPtr\n"
"        if expr.name==\"for_each_archetype\"\n"
"            loop_depth |> pop()\n"
"            inArchetype --\n"
"        return expr\n"
"    def override visitExprBreak(expr:smart_ptr<ExprBreak>) : ExpressionPtr\n"
"        if inClosure!=0 || inArchetype!=0 || loop_depth|>back!=0\n"
"            return expr\n"
"        return make_static_assert_false(\"break is not allowed inside this macros"
"'s block {loop_depth}\", expr.at)\n"
"    def override visitExprContinue(expr:smart_ptr<ExprContinue>) : ExpressionPtr"
"\n"
"        if inClosure!=0 || inArchetype!=0 || loop_depth|>back!=0\n"
"            return expr\n"
"        return make_static_assert_false(\"continue is not allowed inside this mac"
"ros's block {loop_depth}\", expr.at)\n"
"\n"
"[macro_function]\n"
"def public convert_block_to_loop(var blk:smart_ptr<Expression>; failOnReturn,rep"
"laceReturnWithContinue,requireContinueCond:bool )\n"
"    var astVisitor = new B2LVisitor(failOnReturn,replaceReturnWithContinue,requi"
"reContinueCond)\n"
"    var astVisitorAdapter <- make_visitor(*astVisitor)\n"
"    visit(blk, astVisitorAdapter)\n"
"    astVisitorAdapter := null\n"
"    unsafe\n"
"        delete astVisitor\n"
"\n"
