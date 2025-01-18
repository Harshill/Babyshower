PreventLetters = {
    mounted() {
      // Reference: https://stackoverflow.com/a/68822305
      function preventLetters(el) {//returns ###-###-####
        input = el.value
        
        // instead of using regex to strip out non-numeric characters, we can use the following:
        // https://stackoverflow.com/a/18646785
        // https://stackoverflow.com/a/18646785/14972109
        input = input.replace(/\D/g,'');
        console.log(input)
        el.value = input
      }
  
      this.el.addEventListener("input", () => preventLetters(this.el))
    }
  }
  
  export default PreventLetters