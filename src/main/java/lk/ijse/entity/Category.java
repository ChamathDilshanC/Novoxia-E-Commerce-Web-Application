package lk.ijse.entity;

import com.google.gson.annotations.Expose;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Entity
@Table(name = "categories")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Category {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Expose
    private Integer id;

    @Column(nullable = false, length = 100)
    @Expose
    private String name;

    @Expose
    private String description;

    @OneToMany(mappedBy = "category")
    private List<Product> products;
}