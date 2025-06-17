package org.eo.mall.controller;

import java.util.Map;

import org.eo.mall.dto.LoginRequest;
import org.eo.mall.dto.SignUpRequest;
import org.eo.mall.dto.VerifyCodeRequest;
import org.eo.mall.entity.User;
import org.eo.mall.service.AuthService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/send-verification")
    public ResponseEntity<?> sendVerificationCode(@RequestBody Map<String, String> payload) {
        try {
            authService.sendVerificationCode(payload.get("email"));
            return ResponseEntity.ok().body(Map.of("message", "인증 코드가 발송되었습니다."));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
    
    @PostMapping("/verify-code")
    public ResponseEntity<?> verifyCode(@RequestBody VerifyCodeRequest request) {
    	try {
    		if(authService.verifyCode(request)) {
    			return ResponseEntity.ok().body(Map.of("message", "인증되었습니다."));
    		}
    		return ResponseEntity.badRequest().build();
    	} catch (Exception e) {
    		return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
    	}
    }
    
    @PostMapping("/signup")
    public ResponseEntity<?> signUp(@RequestBody SignUpRequest request) {
        try {
            User user = authService.signUp(request);
            user.setPassword(null); 
            return ResponseEntity.ok(user);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest request) {
        try {
            User user = authService.login(request);
            user.setPassword(null);
            return ResponseEntity.ok(user);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
}