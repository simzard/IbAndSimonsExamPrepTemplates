package facades;

import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Query;

import entities.Person;

public class PersonFacade {

    private EntityManagerFactory emf;

    public PersonFacade(EntityManagerFactory emf) {
        this.emf = emf;
    }

    EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public Person addPerson(Person x) {
        EntityManager em = getEntityManager();

        try {
            em.getTransaction().begin();
            em.persist(x);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
        return x;
    }

    public Person deletePerson(int id) {
        EntityManager em = getEntityManager();

        Person personToDelete = em.find(Person.class, id);

        // Use the entity manager  
        try {
            em.getTransaction().begin();
            em.remove(personToDelete);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
        return personToDelete;
    }

    public Person getPerson(int id) {

	EntityManager em = getEntityManager();

        Person personToGet = em.find(Person.class, id);

        return personToGet;

    }

    public List<Person> getPersons() {
        List<Person> persons = null;
        EntityManager em = getEntityManager();
        try {

            // Use the entity manager  
            Query query
                    = em.createQuery("Select x FROM Person x");
            persons = query.getResultList();

        } finally {
            em.close();
        }
        return persons;
    }

    public Person editPerson(Person x) {
        EntityManager em = getEntityManager();
        Person personToEdit = em.find(Person.class, x.getId());

        try {

            em.getTransaction().begin();

            // copy and persist
            personToEdit.setName(x.getName());
            personToEdit.setAge(x.getAge());
            personToEdit.setPrice(x.getPrice());
            personToEdit.setHeight(x.getHeight());
            em.persist(personToEdit);

            em.getTransaction().commit();

        } finally {
            em.close();
        }

        return personToEdit;

    }

}

