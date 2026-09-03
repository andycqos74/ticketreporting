(function () {
  var scanBtn = document.getElementById('scanBtn');
  var stopBtn = document.getElementById('scanStopBtn');
  var wrap = document.getElementById('qrReaderWrap');
  var idInput = document.getElementById('id');
  var html5QrCode;

  if (!scanBtn || typeof Html5Qrcode === 'undefined') return;

  function stopScan() {
    wrap.style.display = 'none';
    if (html5QrCode) {
      html5QrCode.stop().catch(function () {});
    }
  }

  scanBtn.addEventListener('click', function () {
    wrap.style.display = 'block';
    html5QrCode = new Html5Qrcode('qrReader');
    html5QrCode
      .start(
        { facingMode: 'environment' },
        { fps: 10, qrbox: 250 },
        function (decodedText) {
          idInput.value = decodedText;
          stopScan();
          document.getElementById('lookupForm').submit();
        }
      )
      .catch(function (err) {
        alert('Could not start camera: ' + err);
        wrap.style.display = 'none';
      });
  });

  stopBtn.addEventListener('click', stopScan);
})();
