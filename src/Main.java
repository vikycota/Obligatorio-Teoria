import java.io.FileReader;
public class Main {
  public static void main(String[] args) throws Exception {
    new parser(new Lexer(new FileReader(args[0]))).parse();
  }
}