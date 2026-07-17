// Script que envia os dados do formulário para o backend.
// Por padrão aponta para o service `backend` dentro do cluster Kubernetes.
$("#button-blue").on("click", function() {
    var txt_nome = $("#name").val();
    var txt_email = $("#email").val();
    var txt_comentario = $("#comment").val();

    var requestUrl = "http://backend/index.php"; // Ajuste conforme deploy (ex: http://<LB_IP>/index.php)

    $.ajax({
        url: requestUrl,
        type: "post",
        dataType: 'json',
        data: {nome: txt_nome, comentario: txt_comentario, email: txt_email},
        beforeSend: function() {
            console.log("Tentando enviar os dados....");
        }
    }).done(function(resp) {
        if (resp && resp.success) {
            alert("Dados Salvos");
        } else if (resp && resp.error) {
            alert("Erro: " + resp.error);
        } else {
            alert("Resposta inesperada do servidor");
        }
    }).fail(function(jqxhr, status, err) {
        console.error('Request failed', status, err);
        alert('Falha ao enviar dados: ' + status);
    });
});