<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Category Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Category Management</h2>
        <button class="btn btn-primary" onclick="showAddModal()">Add New Category</button>
    </div>

    <div class="card">
        <div class="card-body">
            <table class="table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Description</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody id="categoryTableBody"></tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    loadCategories();

    function loadCategories() {
        fetch('category')
            .then(res => res.json())
            .then(categories => {
                const tbody = document.getElementById('categoryTableBody');
                tbody.innerHTML = categories.map(cat => `
                        <tr>
                            <td>${cat.id}</td>
                            <td>${cat.name}</td>
                            <td>${cat.description || ''}</td>
                            <td>
                                <button class="btn btn-sm btn-warning" onclick='editCategory(${JSON.stringify(cat)})'>Edit</button>
                                <button class="btn btn-sm btn-danger" onclick='deleteCategory(${cat.id})'>Delete</button>
                            </td>
                        </tr>
                    `).join('');
            })
            .catch(() => Swal.fire('Error', 'Failed to load categories', 'error'));
    }

    function showAddModal() {
        Swal.fire({
            title: 'Add Category',
            html: `
                    <input id="name" class="swal2-input" placeholder="Name">
                    <input id="description" class="swal2-input" placeholder="Description">
                `,
            showCancelButton: true,
            preConfirm: () => ({
                name: document.getElementById('name').value,
                description: document.getElementById('description').value
            })
        }).then((result) => {
            if (result.isConfirmed) {
                fetch('category', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify(result.value)
                })
                    .then(res => res.json())
                    .then(data => {
                        if(data.status === 'success') {
                            Swal.fire('Success', 'Category added', 'success');
                            loadCategories();
                        } else {
                            throw new Error(data.message);
                        }
                    })
                    .catch(err => Swal.fire('Error', err.message, 'error'));
            }
        });
    }

    function editCategory(category) {
        Swal.fire({
            title: 'Edit Category',
            html: `
                    <input id="name" class="swal2-input" value="${category.name}" placeholder="Name">
                    <input id="description" class="swal2-input" value="${category.description || ''}" placeholder="Description">
                `,
            showCancelButton: true,
            preConfirm: () => ({
                id: category.id,
                name: document.getElementById('name').value,
                description: document.getElementById('description').value
            })
        }).then((result) => {
            if (result.isConfirmed) {
                fetch('category', {
                    method: 'PUT',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify(result.value)
                })
                    .then(res => res.json())
                    .then(data => {
                        if(data.status === 'success') {
                            Swal.fire('Success', 'Category updated', 'success');
                            loadCategories();
                        } else {
                            throw new Error(data.message);
                        }
                    })
                    .catch(err => Swal.fire('Error', err.message, 'error'));
            }
        });
    }

    function deleteCategory(id) {
        Swal.fire({
            title: 'Are you sure?',
            text: "This action cannot be undone",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33'
        }).then((result) => {
            if (result.isConfirmed) {
                fetch(`category?id=${id}`, {method: 'DELETE'})
                    .then(res => res.json())
                    .then(data => {
                        if(data.status === 'success') {
                            Swal.fire('Deleted!', 'Category has been deleted', 'success');
                            loadCategories();
                        } else {
                            throw new Error(data.message);
                        }
                    })
                    .catch(err => Swal.fire('Error', err.message, 'error'));
            }
        });
    }
</script>
</body>
</html>