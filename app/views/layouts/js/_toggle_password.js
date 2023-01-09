$("#toggle-password").click(function () {
  if ($(".input-password").attr("type") == "password") {
    $(".input-password").attr("type", "text");
    $("#icon-eye").addClass("bi-eye").removeClass("bi-eye-slash");
  } else {
    $(".input-password").attr("type", "password");
    $("#icon-eye").addClass("bi-eye-slash").removeClass("bi-eye");
  }
});
