package org.eo.mall.dto;

import lombok.Data;

@Data
public class VerifyCodeRequest {
	private String email;
	private String verificationCode;
}
