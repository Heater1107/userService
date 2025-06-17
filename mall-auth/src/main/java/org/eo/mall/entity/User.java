package org.eo.mall.entity;

import java.time.LocalDateTime;

import org.eo.mall.status.UserRole;
import org.eo.mall.status.UserStatus;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "user")
public class User {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "user_id")
	private Long id;

	@Column(name = "email", nullable = false, length = 100)
	private String email;

	@Column(name = "pw", nullable = false, length = 100)
	private String password;

	@Column(name = "`name`", nullable = false, length = 30)
	private String name;

	@Column(name = "tel", nullable = false, length = 50)
	private String tel;

	@Column(name = "`status`", nullable = false, length = 20)
	private UserStatus status;

	@Column(name = "agree_terms_at", nullable = false)
	private LocalDateTime agreeTerms;

	@Column(name = "agree_privacy_at", nullable = false)
	private LocalDateTime agreePrivacy;

	@Column(name = "agree_marketing_at", nullable = false)
	private LocalDateTime agreeMarketing;

	@Column(name = "created_at", nullable = true)
	private LocalDateTime createdAt;

	@Column(name = "deleted_at", nullable = true)
	private LocalDateTime deletedAt;

	@Column(name = "last_login_at", nullable = true)
	private LocalDateTime lastLoginAt;

	@Column(name = "profile_img", nullable = true)
	private String profile;
	
	@Column(name = "company_name", nullable = true, length = 100)
	private String companyName;
	
	@Enumerated(EnumType.STRING)
	@Column(name = "role", nullable = false, length = 20)
	private UserRole role;

	@Column(name = "business_registration_num", nullable = true)
	private String businessNum;
	
}
