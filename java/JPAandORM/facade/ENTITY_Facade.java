package facades;

import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Query;

public class ENTITY_Facade {

    private EntityManagerFactory emf;

    public ENTITY_Facade(EntityManagerFactory emf) {
        this.emf = emf;
    }

    EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public ENTITY_ addENTITY_(ENTITY_ x) {
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

    public ENTITY_ deleteENTITY_(int id) {
        EntityManager em = getEntityManager();

        ENTITY_ entity_ToDelete = em.find(ENTITY_.class, id);

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

    public ENTITY_ getENTITY_(int id) {

	EntityManager em = getEntityManager();

        ENTITY_ entity_ToGet = em.find(ENTITY_.class, id);

        return entity_ToGet;

    }

    public List<ENTITY_> getENTITY_s() {
        List<ENTITY_> entity_s = null;
        EntityManager em = getEntityManager();
        try {

            // Use the entity manager  
            Query query
                    = em.createQuery("Select x FROM ENTITY_ x");
            entity_s = query.getResultList();

        } finally {
            em.close();
        }
        return entity_s;
    }

    public ENTITY_ editENTITY_(ENTITY_ x) {
        EntityManager em = getEntityManager();
        ENTITY_ entity_ToEdit = em.find(ENTITY_.class, x.getId());

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

