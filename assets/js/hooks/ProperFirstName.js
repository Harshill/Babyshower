ProperFirstName = {
    mounted() {
      // Reference: https://stackoverflow.com/a/68822305
      function properFirstName(el) {//returns ###-###-####
        input = el.value
        
        // replace any spaces or special characters with nothing
        input = input.replace(/[^a-zA-Z]/g, '');

        el.value = input
      }
  
      this.el.addEventListener("input", () => properFirstName(this.el))
    }
  }
  
  export default ProperFirstName