package org.eo.mall.service;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class EmailService {

    // private final JavaMailSender mailSender; 

    public void sendVerificationEmail(String to, String code) {
        log.info("============== 이메일 발송 ==============");
        log.info("받는 사람: {}", to);
        log.info("인증 코드: {}", code);
        log.info("========================================");
        System.out.println("인증코드 : " + code + "받은 사람 : " + to);
    }
}