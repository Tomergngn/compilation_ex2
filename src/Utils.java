import java_cup.runtime.Symbol;

public class Utils {
    static String SymbolToString(Symbol s, int line, int column) {
        String name = TokenNames.terminalNames[s.sym];
        String value_str = "";
        String location = "[" + line + "," + column + "]";
        if (s.value != null) {
            value_str = s.value.toString();
            if (s.sym == TokenNames.STRING)
            {
                value_str = "\"" + value_str + "\"";
            }
            value_str = "(" + value_str + ")";
        }

        return name + value_str + location;
    }
}