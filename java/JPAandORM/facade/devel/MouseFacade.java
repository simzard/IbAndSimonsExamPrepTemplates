package facades;

import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Query;

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

        Person entity_ToDelete = em.find(Person.class, id);

        // Use the entity manager  
        try {
            em.getTransaction().begin();
            em.remove(entity_ToDelete);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
        return entity_ToDelete;
    }

    public Person getPerson(int id) {

	EntityManager em = getEntityManager();

        Person entity_ToGet = em.find(Person.class, id);

        return entity_ToGet;

    }

    public List<Person> getPersons() {
        List<Person> entity_s = null;
        EntityManager em = getEntityManager();
        try {

            // Use the entity manager  
            Query query
                    = em.createQuery("Select x FROM Person x");
            entity_s = query.getResultList();

        } finally {
            em.close();
        }
        return entity_s;
    }

    public Person editPerson(Person x) {
        EntityManager em = getEntityManager();
        Person entity_ToEdit = em.find(Person.class, x.getId());

        try {

            em.getTransaction().begin();

            // overwrite ALL attributes in the object we want to edit
            entity_ToEdit.setEntityAttrib1(x.getEntityAttrib1());
            entity_ToEdit.setEntityAttrib2(x.getEntityAttrib2());
            // ...
            entity_ToEdit.setEntityAttribN(x.getEntityAttribN());

            // and persist 
            em.persist(entity_ToEdit);
            em.getTransaction().commit();

        } finally {
            em.close();
        }

        return entity_ToEdit;

    }

}

