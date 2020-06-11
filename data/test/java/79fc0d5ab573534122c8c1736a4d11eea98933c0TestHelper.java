import java.io.IOException;

/**
 * Created by siiri on 23/05/15.
 */

public class TestHelper {

    public static void createDb() throws IOException, InterruptedException {

        ProcessBuilder process = new ProcessBuilder("createdb", "-T", "test", "current_test");
        process.redirectOutput(ProcessBuilder.Redirect.INHERIT);
        process.redirectError(ProcessBuilder.Redirect.INHERIT);
        Process p = process.start();
        p.waitFor();




    }

    public static void dropDb() throws IOException, InterruptedException {

        ProcessBuilder process = new ProcessBuilder("dropdb", "current_test");
        process.redirectOutput(ProcessBuilder.Redirect.INHERIT);
        process.redirectError(ProcessBuilder.Redirect.INHERIT);
        process.start().waitFor();


    }
}
