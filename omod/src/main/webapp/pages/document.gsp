<% ui.decorateWith("appui", "standardEmrPage") %>

<style>
    #progress-bar {
        margin: 8px;
        width: auto;
        background-color: lightgray;
    }

    #progress {
        width: 1%;
        height: 30px;
        background-color: green;
        text-align: center;
        color: white;
    }
</style>

<label for="file-input">File:</label>
<input id="file-input" type="file">

<button id="send">Send</button>

<div id="progress-bar">
    <div id="progress"></div>
</div>

<script>
    const sendButton = document.querySelector('#send');
    sendButton.addEventListener(
        'click',
        function (e) {
            console.log("Send button clicked");
            uploadFile();
        },
        false);

    const fileInput = document.querySelector('#file-input');

    function uploadFile() {
        var file = fileInput.files[0];

        if(file){
            console.log(file.name, " selected.");
            initUpload(file);
        } else {
            console.log("Please select the file.")
        }
    }

    function initUpload(file) {
        var xhr = new XMLHttpRequest();
        var uri = "upload.form";
        xhr.open("POST", uri);
        xhr.overrideMimeType('text/plain; charset=x-user-defined-binary');

        xhr.upload.onprogress = function(e) {
            var percentComplete = Math.ceil((e.loaded / e.total) * 100);
            console.log(percentComplete);
            updateProgress(percentComplete);
        };

        xhr.onreadystatechange = function() {
            console.log("----- readyState changed -----");
            console.log("readyState :", xhr.readyState);
            console.log("Response :", xhr.responseText);
            if (xhr.readyState === 4) {
                console.log("Upload finish");
            }
        };

        var formData = new FormData();
        var reader = new FileReader();
        reader.onload = (function (e) {
            var previewFile = e.target.result;
            formData.append("filename", file.name);
            formData.append("file", previewFile);
            xhr.send(formData);
        });
        reader.readAsDataURL(file);
    }

    var elem = document.getElementById("progress");

    function updateProgress(progress) {
        elem.style.width = progress + '%';
        elem.innerHTML = progress + '%';
    }

</script>