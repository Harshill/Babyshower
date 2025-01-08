FormatPhoneNumberOnInput = {
  mounted() {
    // Reference: https://stackoverflow.com/a/68822305
    function formatPhoneNumber(el) {//returns ###-###-####
      input = el.value

      input = input.replace(/\D/g,'').substring(0,10); //Strip everything but 1st 10 digits
      var size = input.length;
      if (size>3) {input=input.slice(0,3)+"-"+input.slice(3)}
      if (size>7) {input=input.slice(0,7)+"-" +input.slice(7)}

      el.value = input
    }

    this.el.addEventListener("input", () => formatPhoneNumber(this.el))
  }
}

export default FormatPhoneNumberOnInput