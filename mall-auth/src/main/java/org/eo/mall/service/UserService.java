package org.eo.mall.service;

import org.eo.mall.entity.User;
import org.eo.mall.repository.UserRepository;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserService {
	
	private final UserRepository userRepository;
	
	public String getCompanyNameById(Long userId) {
	    return userRepository.findById(userId)
	            .map(User::getCompanyName)
	            .orElse("미상호명");
	}
}
