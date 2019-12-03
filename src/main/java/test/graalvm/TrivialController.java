package test.graalvm;

import io.micronaut.http.MediaType;
import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Get;

@Controller("healthcheck")
public class TrivialController {
    @Get(produces = MediaType.TEXT_PLAIN)
    public String index() {
        return "GraalVM image health OK";
    }
}