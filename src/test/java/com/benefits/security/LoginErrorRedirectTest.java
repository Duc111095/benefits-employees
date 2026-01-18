package com.benefits.security;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
public class LoginErrorRedirectTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    public void accessToErrorPage_ShouldNotRedirectToLogin() throws Exception {
        // Accessing /error directly should now be permitted.
        // It returns 500 because we are hitting it without context, but crucial thing
        // is it is NOT 302.

        mockMvc.perform(get("/error"))
                .andExpect(status().isInternalServerError()); // Expect 500
    }

    @Test
    public void accessToFavicon_ShouldNotRedirectToLogin() throws Exception {
        mockMvc.perform(get("/favicon.ico"))
                .andExpect(status().is4xxClientError()); // Likely 404 if no favicon, but not 302
    }
}
