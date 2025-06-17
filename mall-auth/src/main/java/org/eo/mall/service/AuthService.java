package org.eo.mall.service;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.concurrent.TimeUnit;

import org.eo.mall.dto.LoginRequest;
import org.eo.mall.dto.SignUpRequest;
import org.eo.mall.dto.VerifyCodeRequest;
import org.eo.mall.entity.User;
import org.eo.mall.repository.UserRepository;
import org.eo.mall.status.UserRole;
import org.eo.mall.status.UserStatus;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final StringRedisTemplate redisTemplate;
    private final EmailService emailService;

    private static final String AUTH_CODE_PREFIX = "AuthCode:";

    public void sendVerificationCode(String email) {
        if (userRepository.existsByEmail(email)) {
            throw new IllegalArgumentException("이미 가입된 이메일입니다.");
        }
        String code = createCode();
        emailService.sendVerificationEmail(email, code);
        redisTemplate.opsForValue().set(AUTH_CODE_PREFIX + email, code, 5, TimeUnit.MINUTES);
    }
    
    public boolean verifyCode(VerifyCodeRequest request) {
    	String storedCode = redisTemplate.opsForValue().get(AUTH_CODE_PREFIX + request.getEmail());
    	if(storedCode == null || !storedCode.equals(request.getVerificationCode())) {
    		throw new IllegalArgumentException("인증 코드 다름");
    	}
    	return true;
    }
    
    @Transactional
    public User signUp(SignUpRequest request) {
        String storedCode = redisTemplate.opsForValue().get(AUTH_CODE_PREFIX + request.getEmail());
        if (storedCode == null || !storedCode.equals(request.getVerificationCode())) {
            throw new IllegalArgumentException("인증 코드가 일치하지 않습니다.");
        }

        if (request.getRole() == UserRole.SELLER && (request.getBusinessNum() == null || request.getBusinessNum().isBlank())) {
            throw new IllegalArgumentException("판매자는 사업자 등록번호를 입력해야 합니다.");
        }

        User user = User.builder()
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .name(request.getName())
                .tel(request.getTel())
                .role(request.getRole())
                .businessNum(request.getRole() == UserRole.SELLER ? request.getBusinessNum() : null)
                .companyName(request.getRole() == UserRole.SELLER ? request.getCompanyName() : null)
                .status(UserStatus.ACTIVE)
                .agreeTerms(LocalDateTime.now()) 
                .agreePrivacy(LocalDateTime.now())
                .agreeMarketing(LocalDateTime.now())
                .createdAt(LocalDateTime.now())
                .build();
        
        User savedUser = userRepository.save(user);

        redisTemplate.delete(AUTH_CODE_PREFIX + request.getEmail());

        return savedUser;
    }

    public User login(LoginRequest request) {
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 이메일입니다."));
        
        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new IllegalArgumentException("비밀번호가 일치하지 않습니다.");
        }
        
        user.setLastLoginAt(LocalDateTime.now());
        return userRepository.save(user);
    }

    private String createCode() {
        SecureRandom random = new SecureRandom();
        return String.valueOf(100000 + random.nextInt(900000)); 
    }
}