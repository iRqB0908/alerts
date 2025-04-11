window.addEventListener('message', function(event) {
    const data = event.data;
    if (data.action === 'showAlert') {
      document.getElementById('alert-message').innerText = data.message;
      document.getElementById('alert-box').style.display = 'block';
    } else if (data.action === 'hideAlert') {
      document.getElementById('alert-box').style.display = 'none';
    }
  });
  