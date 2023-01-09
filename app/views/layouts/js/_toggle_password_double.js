$("#toggle-password-1").click(function () {
  if ($(".input-password-1").attr("type") == "password") {
    $(".input-password-1").attr("type", "text");
    $("#icon-eye-1").addClass("bi-eye").removeClass("bi-eye-slash");
  } else {
    $(".input-password-1").attr("type", "password");
    $("#icon-eye-1").addClass("bi-eye-slash").removeClass("bi-eye");
  }
});

$("#toggle-password-2").click(function () {
  if ($(".input-password-2").attr("type") == "password") {
    $(".input-password-2").attr("type", "text");
    $("#icon-eye-2").addClass("bi-eye").removeClass("bi-eye-slash");
  } else {
    $(".input-password-2").attr("type", "password");
    $("#icon-eye-2").addClass("bi-eye-slash").removeClass("bi-eye");
  }
});
