/* A Bison parser, made by GNU Bison 3.3.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2019 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_SRC_MAIN_TAB_H_INCLUDED
# define YY_YY_SRC_MAIN_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    LP = 258,
    RP = 259,
    LBCT = 260,
    RBCT = 261,
    LB = 262,
    RB = 263,
    IF = 264,
    WHILE = 265,
    FOR = 266,
    RETURN = 267,
    PRINTF = 268,
    SCANF = 269,
    T_CHAR = 270,
    T_INT = 271,
    T_STRING = 272,
    T_BOOL = 273,
    T_VOID = 274,
    SEMICOLON = 275,
    COMMA = 276,
    IDENTIFIER = 277,
    INTEGER = 278,
    CHAR = 279,
    BOOL = 280,
    STRING = 281,
    LOP_ASSIGN = 282,
    LOP_OR = 283,
    LOP_AND = 284,
    LOP_EQ = 285,
    LOP_NEQ = 286,
    LOP_PLUSEQ = 287,
    LOP_SUBEQ = 288,
    LOP_MULTEQ = 289,
    LOP_DIVEQ = 290,
    LOP_MODEQ = 291,
    LOP_G = 292,
    LOP_L = 293,
    LOP_GEQ = 294,
    LOP_LEQ = 295,
    LOP_PLUS = 296,
    LOP_SUB = 297,
    LOP_MULT = 298,
    LOP_DIV = 299,
    LOP_MOD = 300,
    LOP_NOT = 301,
    LOP_LAB = 302,
    LOP_PLUSPLUS = 303,
    LOP_SUBSUB = 304
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_SRC_MAIN_TAB_H_INCLUDED  */
