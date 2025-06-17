package org.eo.mall.dto;

import lombok.Data;
import org.eo.mall.status.UserRole;

@Data
public class SignUpRequest {
    private String email;
    private String password;
    private String name;
    private String tel;
    private String verificationCode;
    private UserRole role;
    private String businessNum;
    private String companyName; 
}