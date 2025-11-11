package com.soict.benefit_employees.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
public class BenefitException extends RuntimeException {
    private final HttpStatus status;
    private final String message;

    public BenefitException(String message, HttpStatus status) {
        super(message);
        this.message = message;
        this.status = status;
    }

    public static BenefitException notFound(String resource) {
        return new BenefitException(resource + " not found", HttpStatus.NOT_FOUND);
    }

    public static BenefitException badRequest(String message) {
        return new BenefitException(message, HttpStatus.BAD_REQUEST);
    }

    public static BenefitException unauthorized(String message) {
        return new BenefitException(message, HttpStatus.UNAUTHORIZED);
    }

    public static BenefitException forbidden(String message) {
        return new BenefitException(message, HttpStatus.FORBIDDEN);
    }
}