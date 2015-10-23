package facades;

import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Query;

import entities.Bob;

public class BobFacade {

    private EntityManagerFactory emf;

    public BobFacade(EntityManagerFactory emf) {
        this.emf = emf;
    }

    EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public Bob addBob(Bob x) {
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

    public Bob deleteBob(int id) {
        EntityManager em = getEntityManager();

        Bob bobToDelete = em.find(Bob.class, id);

        // Use the entity manager  
        try {
            em.getTransaction().begin();
            em.remove(bobToDelete);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
        return bobToDelete;
    }

    public Bob getBob(int id) {

	EntityManager em = getEntityManager();

        Bob bobToGet = em.find(Bob.class, id);

        return bobToGet;

    }

    public List<Bob> getBobs() {
        List<Bob> bobs = null;
        EntityManager em = getEntityManager();
        try {

            // Use the entity manager  
            Query query
                    = em.createQuery("Select x FROM Bob x");
            bobs = query.getResultList();

        } finally {
            em.close();
        }
        return bobs;
    }

    public Bob editBob(Bob x) {
        EntityManager em = getEntityManager();
        Bob bobToEdit = em.find(Bob.class, x.getId());

        try {

            em.getTransaction().begin();

            // overwrite ALL attributes in the object we want to edit
            bobToEdit.setEntityAttrib1(x.getEntityAttrib1());
            bobToEdit.setEntityAttrib2(x.getEntityAttrib2());
            // ...
            bobToEdit.setEntityAttribN(x.getEntityAttribN());

            // and persist 
            em.persist(bobToEdit);
            em.getTransaction().commit();

        } finally {
            em.close();
        }

        return bobToEdit;

    }

}

