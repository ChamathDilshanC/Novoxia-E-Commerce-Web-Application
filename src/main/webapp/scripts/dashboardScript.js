window.history.pushState(null, null, window.location.href);
window.onpopstate = function () {
    window.history.pushState(null, null, window.location.href);
};
// navigation
document.querySelectorAll('.step-item').forEach(item => {
    item.addEventListener('click', () => {
        document.querySelectorAll('.step-item').forEach(el => el.classList.remove('active'));
        item.classList.add('active');
    });
});

// Quick link cards hover effect
document.querySelectorAll('.quick-link-card').forEach(card => {
    card.addEventListener('mouseover', () => {
        card.style.transform = 'translateY(-5px)';
        card.style.boxShadow = '0 4px 12px rgba(0, 0, 0, 0.1)';
    });

    card.addEventListener('mouseout', () => {
        card.style.transform = 'translateY(0)';
        card.style.boxShadow = '0 1px 3px rgba(0, 0, 0, 0.1)';
    });
});

// Logout confirmation
document.getElementById('logoutForm').addEventListener('submit', function(e) {
    e.preventDefault();
    Swal.fire({
        text: 'Are you sure you want to log out?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#dc3545',
        cancelButtonColor: '#6c757d',
        confirmButtonText: 'Yes, log out',
        cancelButtonText: 'Cancel'
    }).then((result) => {
        if (result.isConfirmed) {
            this.submit();
        }
    });
});

// Active link highlight
const currentPage = window.location.pathname.split('/').pop();
document.querySelectorAll('.nav-link').forEach(link => {
    if (link.getAttribute('href') === currentPage) {
        link.classList.add('active');
    } else {
        link.classList.remove('active');
    }
});

// Step item navigation
document.querySelectorAll('.step-item').forEach((item, index) => {
    item.addEventListener('click', function() {
        if (!this.classList.contains('active') && !this.querySelector('form')) {
            const links = ['dashboard.jsp', 'products.jsp', 'categories.jsp', 'orders.jsp', 'users.jsp'];
            if (links[index]) {
                window.location.href = links[index];
            }
        }
    });
});