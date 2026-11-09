import java.util.Set;

public class Validador {
    private static final Set<String> DIAS = Set.of(
        "lunes", "martes", "miércoles", "miercoles", "jueves",
        "viernes", "sábado", "sabado", "domingo");
    private static final Set<String> NIVELES = Set.of(
        "principiante", "intermedio", "avanzado");

    public static boolean esDia(String s)   { return DIAS.contains(s.toLowerCase()); }
    public static boolean esNivel(String s) { return NIVELES.contains(s.toLowerCase()); }

    public static void error(int linea, String msg) {
        System.err.println("[Línea " + linea + "] Error semántico: " + msg);
    }
}
