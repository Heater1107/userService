package org.eo.mall.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

	private final RestTemplate restTemplate = new RestTemplate();
	private final ObjectMapper objectMapper;
	private final String GATEWAY_API_URL = "http://localhost:8080/api/auth";

	@GetMapping("/signup")
	public String signupStep1Page() {
		return "pages/signup_step1";
	}

	@GetMapping("/signup/step2")
	public String signupStep2Page(HttpSession session) {
		if (session.getAttribute("loginUser") == null) {
			return "redirect:/api/auth/signup";
		}
		return "pages/signup_step2";
	}

	@PostMapping("/signup/step1")
	public String handleSignupStep1(@RequestParam Map<String, String> formData, HttpSession session) {
		String fullEmail = formData.get("email") + "@" + formData.get("emailDomain");
		Map<String, String> signupData = new HashMap<>(formData);
		signupData.put("fullEmail", fullEmail);
		
		session.setAttribute("loginUser", signupData);
		
		return "redirect:/api/auth/signup/step2";
	}
	
	/** 이거 403 겁나 뜸 */
	@PostMapping("/signup/step2")
	public String handleSignupStep2(@RequestParam(required = false) Map<String, String> termsData, HttpSession session,
			RedirectAttributes redirectAttributes) {

		@SuppressWarnings("unchecked")
		Map<String, String> loginUser = (Map<String, String>) session.getAttribute("loginUser");

		if (loginUser == null) {
			redirectAttributes.addFlashAttribute("error", "회원가입 정보가 만료되었습니다. 처음부터 다시 시도해주세요.");
			return "redirect:/api/auth/signup";
		}

		Map<String, Object> finalSignupRequest = new HashMap<>();
		finalSignupRequest.put("email", loginUser.get("fullEmail"));
		finalSignupRequest.put("password", loginUser.get("password"));
		finalSignupRequest.put("name", loginUser.get("name"));
		finalSignupRequest.put("tel", loginUser.get("tel"));
		finalSignupRequest.put("verificationCode", loginUser.get("verificationCode"));
		finalSignupRequest.put("role", loginUser.get("role"));
		
		if ("SELLER".equals(loginUser.get("role"))) {
			finalSignupRequest.put("businessNum", loginUser.get("businessNum"));
			finalSignupRequest.put("companyName", loginUser.get("companyName"));
		}
		
		finalSignupRequest.put("agreeTerms", termsData != null && termsData.containsKey("agreeTerms"));
		finalSignupRequest.put("agreePrivacy", termsData != null && termsData.containsKey("agreePrivacy"));
		finalSignupRequest.put("agreeMarketing", termsData != null && termsData.containsKey("agreeMarketing"));

		try {
			String jsonBody = objectMapper.writeValueAsString(finalSignupRequest);
			HttpHeaders headers = new HttpHeaders();
			headers.setContentType(MediaType.APPLICATION_JSON);
			HttpEntity<String> request = new HttpEntity<>(jsonBody, headers);
			
			restTemplate.postForEntity(GATEWAY_API_URL + "/signup", request, String.class);

			redirectAttributes.addFlashAttribute("message", "회원가입이 성공적으로 완료되었습니다.");
			
			session.removeAttribute("loginUser"); 
			
			return "redirect:/api/auth/login";

		} catch (HttpClientErrorException e) {
			redirectAttributes.addFlashAttribute("error", "회원가입 처리 중 오류가 발생했습니다: " + e.getResponseBodyAsString());
			return "redirect:/api/auth/signup";
		} catch (JsonProcessingException e) {
			redirectAttributes.addFlashAttribute("error", "데이터 처리 중 오류가 발생했습니다.");
			return "redirect:/api/auth/signup";
		}
	}

	@GetMapping("/login")
	public String loginPage() {
		return "pages/login";
	}

	@PostMapping("/login")
	public String login(@RequestParam String email, @RequestParam String password, HttpServletRequest request,
			RedirectAttributes redirectAttributes) {
		try {
			Map<String, String> body = Map.of("email", email, "password", password);
			HttpHeaders headers = new HttpHeaders();
			headers.setContentType(MediaType.APPLICATION_JSON);
			HttpEntity<Map<String, String>> entity = new HttpEntity<>(body, headers);
			
			ResponseEntity<String> response = restTemplate.postForEntity(GATEWAY_API_URL + "/login", entity, String.class);

			HttpSession session = request.getSession();
			session.setAttribute("user", response.getBody());
			session.setAttribute("userName", objectMapper.readTree(response.getBody()).get("name").asText());
			return "redirect:/";
		} catch (HttpClientErrorException | JsonProcessingException e) {
			redirectAttributes.addFlashAttribute("error", "로그인 실패: " + e.getMessage());
			return "redirect:/api/auth/login";
		}
	}

	@GetMapping("/logout")
	public String logout(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if (session != null) {
			session.invalidate();
		}
		return "redirect:/api/auth/login";
	}

	@PostMapping("/send-verification")
	@ResponseBody
	public ResponseEntity<?> sendVerificationCode(@RequestBody Map<String, String> payload) {
		try {
			restTemplate.postForEntity(GATEWAY_API_URL + "/send-verification", new HttpEntity<>(payload), String.class);
			return ResponseEntity.ok(Map.of("message", "인증 코드가 발송되었습니다."));
		} catch (HttpClientErrorException e) {
			return ResponseEntity.badRequest().body(Map.of("error", e.getResponseBodyAsString()));
		}
	}
	
	@PostMapping("/verify-code")
	@ResponseBody
	public ResponseEntity<?> proxyVerifyCOde(@RequestBody Map<String, String> payload) {
		try {
			HttpEntity<Map<String, String>> request = new HttpEntity<Map<String,String>>(payload, new HttpHeaders() {{ setContentType(MediaType.APPLICATION_JSON);}});
			return restTemplate.postForEntity(GATEWAY_API_URL + "/verify-code", request, String.class);
		} catch (HttpClientErrorException e) {
			return ResponseEntity.badRequest().body(e.getResponseBodyAsString());
		}
	}
}









