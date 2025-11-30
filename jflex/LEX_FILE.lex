/***************************/
/* FILE NAME: LEX_FILE.lex */
/***************************/

/*************/
/* USER CODE */
/*************/

import java_cup.runtime.*;

/******************************/
/* DOLLAR DOLLAR - DON'T TOUCH! */
/******************************/

%%

/************************************/
/* OPTIONS AND DECLARATIONS SECTION */
/************************************/
   
/*****************************************************/ 
/* Lexer is the name of the class JFlex will create. */
/* The code will be written to the file Lexer.java.  */
/*****************************************************/ 
%class Lexer

/********************************************************************/
/* The current line number can be accessed with the variable yyline */
/* and the current column number with the variable yycolumn.        */
/********************************************************************/
%line
%column

/*******************************************************************************/
/* Note that this has to be the EXACT same name of the class the CUP generates */
/*******************************************************************************/
%cupsym TokenNames

/******************************************************************/
/* CUP compatibility mode interfaces with a CUP generated parser. */
/******************************************************************/
%cup

/****************/
/* DECLARATIONS */
/****************/
/*****************************************************************************/   
/* Code between %{ and %}, both of which must be at the beginning of a line, */
/* will be copied verbatim (letter to letter) into the Lexer class code.     */
/* Here you declare member variables and functions that are used inside the  */
/* scanner actions.                                                          */  
/*****************************************************************************/   
%{
	/*********************************************************************************/
	/* Create a new java_cup.runtime.Symbol with information about the current token */
	/*********************************************************************************/
	private Symbol symbol(int type)               {return new Symbol(type, yyline, yycolumn);}
	private Symbol symbol(int type, Object value) {return new Symbol(type, yyline, yycolumn, value);}
	private static final int MAX_INTEGER_VALUE = 32767;
	private static final int MIN_INTEGER_VALUE = 0;

	/*******************************************/
	/* Enable line number extraction from main */
	/*******************************************/
	public int getLine() { return yyline + 1; }
	public int getColumn() { return yycolumn + 1; }

	/**********************************************/
	/* Enable token position extraction from main */
	/**********************************************/
	public int getTokenStartPosition() { return yycolumn + 1; }
%}

/***********************/
/* MACRO DECLARATIONS */
/***********************/
LineTerminator	        = \r|\n|\r\n
WhiteSpace		        = {LineTerminator} | [ \t]
INTEGER			        = 0|([1-9][0-9]*)
INVALID_INTEGER         = 0[0-9]+
ID				        = [a-zA-Z][a-zA-Z0-9]*
STRING			        = \"[a-zA-Z]*\"
INVALID_STRING	        = \".*
COMMENT_ALLOWED_CHAR    = [a-zA-Z0-9 \t\(\)\[\]\{\}\?\!\+\-\*\/\.;]
COMMENT_TYPE_1          = \/\/{COMMENT_ALLOWED_CHAR}*
COMMENT_TYPE_2          = \/\*({COMMENT_ALLOWED_CHAR}|\n)*\*\/
INVALID_COMMENT         = ((\/\*) | (\/\/)).*

/******************************/
/* DOLLAR DOLLAR - DON'T TOUCH! */
/******************************/

%%

/************************************************************/
/* LEXER matches regular expressions to actions (Java code) */
/************************************************************/

/**************************************************************/
/* YYINITIAL is the state at which the lexer begins scanning. */
/* So these regular expressions will only be matched if the   */
/* scanner is in the start state YYINITIAL.                   */
/**************************************************************/

<YYINITIAL> {
{COMMENT_TYPE_1}    { /* Skip */ }
{COMMENT_TYPE_2}    { /* Skip */ }
{INVALID_COMMENT}   { throw new Error("Invalid comment: " + yytext()); }
"+"					{ return symbol(TokenNames.PLUS);}
"-"					{ return symbol(TokenNames.MINUS);}
"*"			        { return symbol(TokenNames.TIMES);}
"/"					{ return symbol(TokenNames.DIVIDE);}
"("					{ return symbol(TokenNames.LPAREN);}
")"					{ return symbol(TokenNames.RPAREN);}
"["					{ return symbol(TokenNames.LBRACK);}
"]"					{ return symbol(TokenNames.RBRACK);}
"{"					{ return symbol(TokenNames.LBRACE);}
"}"					{ return symbol(TokenNames.RBRACE);}
","					{ return symbol(TokenNames.COMMA);}
"."					{ return symbol(TokenNames.DOT);}
";"					{ return symbol(TokenNames.SEMICOLON);}
"int"				{ return symbol(TokenNames.TYPE_INT);}
"string"			{ return symbol(TokenNames.TYPE_STRING);}
"void"				{ return symbol(TokenNames.TYPE_VOID);}
":="				{ return symbol(TokenNames.ASSIGN);}
"="				    { return symbol(TokenNames.EQ);}
"<"				    { return symbol(TokenNames.LT);}
">"				    { return symbol(TokenNames.GT);}
"array"			    { return symbol(TokenNames.ARRAY);}
"class"			    { return symbol(TokenNames.CLASS);}
"return"		    { return symbol(TokenNames.RETURN);}
"while"		        { return symbol(TokenNames.WHILE);}
"if"		        { return symbol(TokenNames.IF);}
"else"		        { return symbol(TokenNames.ELSE);}
"new"		        { return symbol(TokenNames.NEW);}
"extends"	        { return symbol(TokenNames.EXTENDS);}
"nil"	            { return symbol(TokenNames.NIL);}
{INVALID_INTEGER}   { throw new Error("Invalid integer: " + yytext());}
{INTEGER}			{
                        Integer value = Integer.valueOf(yytext());
                        if (value > MAX_INTEGER_VALUE || value < MIN_INTEGER_VALUE)
                        {
                            throw new Error("Integer out of bounds: " + yytext());
                        }
                        return symbol(TokenNames.INT, value);
                    }
{STRING}			{
                        String text = yytext();
                        return symbol(TokenNames.STRING, String.valueOf(text).substring(1,text.length()-1));
                    }
{ID}				{ return symbol(TokenNames.ID, yytext());}
{WhiteSpace}		{ /* just skip what was found, do nothing */ }
<<EOF>>				{ return symbol(TokenNames.EOF);}
}
