package facades;

import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Query;

import entities.Simon;

public class SimonFacade {

    private EntityManagerFactory emf;

    public SimonFacade(EntityManagerFactory emf) {
        this.emf = emf;
    }

    EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public Simon addSimon(Simon x) {
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

    public Simon deleteSimon(int id) {
        EntityManager em = getEntityManager();

        Simon simonToDelete = em.find(Simon.class, id);

        // Use the entity manager  
        try {
            em.getTransaction().begin();
            em.remove(simonToDelete);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
        return simonToDelete;
    }

    public Simon getSimon(int id) {

	EntityManager em = getEntityManager();

        Simon simonToGet = em.find(Simon.class, id);

        return simonToGet;

    }

    public List<Simon> getSimons() {
        List<Simon> simons = null;
        EntityManager em = getEntityManager();
        try {

            // Use the entity manager  
            Query query
                    = em.createQuery("Select x FROM Simon x");
            simons = query.getResultList();

        } finally {
            em.close();
        }
        return simons;
    }

    public Simon editSimon(Simon x) {
        EntityManager em = getEntityManager();
        Simon simonToEdit = em.find(Simon.class, x.getId());

        try {

            em.getTransaction().begin();

            // copy and persist
            simonToEdit.setLastName(x.getLastName());

            simonToEdit.setFirstName(x.getFirstName());

            em.persist(simonToEdit);
            em.getTransaction().commit();

        } finally {
            em.close();
        }

        return simonToEdit;

    }

}

