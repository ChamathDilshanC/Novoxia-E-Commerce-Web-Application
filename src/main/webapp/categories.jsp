<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Novoxia - Category Management</title>
    <link rel="icon" type="image/x-icon" href="assets/a.svg">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="styles/categoryStyles.css">
</head>

<body>
<!-- Top Navigation -->
<jsp:include page="components/topnav.jsp" />

<div class="dashboard-container">
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon" style="background-color: #dbeafe; color: #2563eb;">
                <i class="bi bi-collection"></i>
            </div>
            <h3 class="h6 text-muted mb-1">Total Categories</h3>
            <h2 class="h4 mb-0">${categories.size()}</h2>
        </div>
    </div>

    <!-- Categories -->
    <div class="category-container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="h4 mb-0">Category Management</h3>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#categoryModal">
                <i class="bi bi-plus-lg me-2"></i>Add Category
            </button>
        </div>

        <div class="category-grid">
            <c:choose>
                <c:when test="${empty categories}">
                    <div class="col-12">
                        <div class="empty-state">
                            <i class="bi bi-collection"></i>
                            <h4>No Categories Found</h4>
                            <p class="text-muted">Start by adding a new category to the system.</p>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="category" items="${categories}">
                        <div class="category-card">
                            <div class="category-content">
                                <div class="category-title">
                                    <div class="category-icon">
                                        <i class="bi bi-collection"></i>
                                    </div>
                                        ${category.name}
                                </div>
                                <p class="category-description">${category.description}</p>
                            </div>
                            <div class="category-footer">
                                <button class="btn btn-edit" onclick="openEditModal(${category.id}, '${category.name}', '${category.description}')">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <button class="btn btn-delete" onclick="confirmDelete(${category.id}, '${category.name}')">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- Category Modal -->
<div class="modal fade" id="categoryModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">Add Category</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="categoryForm" class="needs-validation" novalidate>
                <div class="modal-body">
                    <input type="hidden" id="categoryId" name="id">
                    <div class="form-floating mb-3">
                        <input type="text" class="form-control" id="categoryName" name="name" required>
                        <label for="categoryName">Category Name</label>
                        <div class="invalid-feedback">Please enter a category name.</div>
                    </div>
                    <div class="form-floating">
                        <textarea class="form-control" id="categoryDescription" name="description" style="height: 100px"></textarea>
                        <label for="categoryDescription">Description</label>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="scripts/categoryScript.js"></script>
</body>
</html>