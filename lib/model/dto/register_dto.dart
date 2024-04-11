class RegisterDTO {
  String fullName;
  String username;
  String email;
  String password;
  String confirmPassword;

  RegisterDTO(this.fullName, this.username, this.email, this.password,
      this.confirmPassword);
}