import java.io.*;
import java_cup.runtime.Symbol;

public class Main
{
    public static void main(String argv[])
    {
        Lexer l = null;
        Parser p;
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

            // Parse the input
            p.parse();

            // If we get here, parsing succeeded
            fileWriter.print("OK");
            fileWriter.close();
        }
        catch (Error e)
        {
            // Lexical or syntax error occurred
            if (fileWriter != null) {
                try {
                    fileWriter.close();
                } catch (Exception ex) {
                    // Ignore
                }
            }
            try {
                fileWriter = new PrintWriter(outputFileName);
                int errorLine = l != null ? l.getLine() : 1;
                fileWriter.print("ERROR(" + errorLine + ")");
                fileWriter.close();
            } catch (Exception ex) {
                System.err.println("An exception occurred while writing error to output file:");
                ex.printStackTrace();
            }
        }
        catch (Exception e)
        {
            // Parsing exception
            if (fileWriter != null) {
                try {
                    fileWriter.close();
                } catch (Exception ex) {
                    // Ignore
                }
            }
            try {
                fileWriter = new PrintWriter(outputFileName);
                int errorLine = l != null ? l.getLine() : 1;
                fileWriter.print("ERROR(" + errorLine + ")");
                fileWriter.close();
            } catch (Exception ex) {
                System.err.println("An exception occurred while writing error to output file:");
                ex.printStackTrace();
            }
        }
    }
}
