package org.eo.mall.controller;

import org.eo.mall.service.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/{userId}/company-name")
    public ResponseEntity<String> getCompanyName(@PathVariable Long userId) {
        String companyName = userService.getCompanyNameById(userId);
        return ResponseEntity.ok(companyName);
    }
}