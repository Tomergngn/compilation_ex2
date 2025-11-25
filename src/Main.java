import java.io.*;
import java.io.PrintWriter;
import java_cup.runtime.Symbol;
import ast.*;

public class Main
{
	private static final String ERROR_FILE_DATA = "ERROR";
	static public void main(String argv[])
	{
		Lexer l;
		Parser p;
		Symbol s;
		AstStmtList ast;
		FileReader fileReader;
		PrintWriter fileWriter = null;
		String inputFileName = argv[0];
		String outputFileName = argv[1];
		
		try
		{
			fileReader = new FileReader(inputFileName);
			fileWriter = new PrintWriter(outputFileName);
			
			l = new Lexer(fileReader);
			
			p = new Parser(l);

			/***********************************/
			/* [5] 3 ... 2 ... 1 ... Parse !!! */
			/***********************************/
			ast = (AstStmtList) p.parse().value;
			
			/*************************/
			/* [6] Print the AST ... */
			/*************************/
			ast.printMe();
			
			/*************************/
			/* [7] Close output file */
			/*************************/
			fileWriter.close();
			
			/*************************************/
			/* [8] Finalize AST GRAPHIZ DOT file */
			/*************************************/
			AstGraphviz.getInstance().finalizeFile();
    	}
        catch (Error e)
        {

            if (fileWriter != null) {
                try {
                    fileWriter.close();
                } catch (Exception ex) {
                    System.err.println("Error closing file writer");
                }
            }
            try {
                fileWriter = new PrintWriter(outputFileName);
                fileWriter.println(ERROR_FILE_DATA);

                fileWriter.close();
            } catch (Exception ex) {
                System.err.println("An exception has occured while trying to set ERROR in output file:");
                ex.printStackTrace();
            }
            e.printStackTrace();
        }
		catch (Exception e)
		{
			e.printStackTrace();
		}
	}