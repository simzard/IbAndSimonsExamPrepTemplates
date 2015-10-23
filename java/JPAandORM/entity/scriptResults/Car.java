package entities;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Car implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private String first;
    private String second;
    private int age;
    private String make;
    private String description;
    private double price;

    public Car() {
    }

    public Car(String first, String second, int age, String make, String description, double price) {
        this.first = first;
        this.second = second;
        this.age = age;
        this.make = make;
        this.description = description;
        this.price = price;
    }

    public Car(Integer id, String first, String second, int age, String make, String description, double price) {
        this.id = id;
        this.first = first;
        this.second = second;
        this.age = age;
        this.make = make;
        this.description = description;
        this.price = price;
    }

    public String getFirst() {
        return first;
    }

    public String getSecond() {
        return second;
    }

    public int getAge() {
        return age;
    }

    public String getMake() {
        return make;
    }

    public String getDescription() {
        return description;
    }

    public double getPrice() {
        return price;
    }

    public void setFirst(String first) {
        this.first = first;
    }

    public void setSecond(String second) {
        this.second = second;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public void setMake(String make) {
        this.make = make;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Car)) {
            return false;
        }
        Car other = (Car) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entities.Car[ id=" + id + " ]";
    }
    
}

