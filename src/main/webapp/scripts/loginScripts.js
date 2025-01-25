$(document).ready(function() {
    $('#loginForm').on('submit', function(e) {
        e.preventDefault();

        const loginBtn = $('#loginBtn');
        const originalBtnText = loginBtn.html();
        loginBtn.prop('disabled', true)
            .html('<span class="spinner-border spinner-border-sm me-2"></span>Signing in...');

        $.ajax({
            url: $(this).attr('action'),
            type: 'POST',
            data: $(this).serialize(),
            dataType: 'json',
            success: function(response) {
                if (response.status === 'success') {
                    $('.step-item').eq(1).addClass('step-active');
                    setTimeout(function() {
                        $('.step-item').eq(2).addClass('step-active');
                        window.location.replace(response.redirect);
                    }, 1000);
                }else {
                    Swal.fire({
                        title: 'Error!',
                        text: response.message,
                        icon: 'error',
                        confirmButtonText: 'OK'
                    });
                    loginBtn.prop('disabled', false).html(originalBtnText);
                }
            },
            error: function() {
                Swal.fire({
                    title: 'Error!',
                    text: 'Something went wrong. Please try again.',
                    icon: 'error',
                    confirmButtonText: 'OK'
                });
                loginBtn.prop('disabled', false).html(originalBtnText);
            }
        });
    });
});

if (window.performance && window.performance.navigation.type === window.performance.navigation.TYPE_BACK_FORWARD) {
    window.location.href = 'dashboard.jsp';
}

    window.history.pushState(null, null, window.location.href);
    window.onpopstate = function () {
    window.history.go(1);
};