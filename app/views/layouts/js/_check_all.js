$(".checkAll").click(function (e) {
  $(this)
    .closest("table")
    .find("td input:checkbox")
    .prop("checked", this.checked);
});
