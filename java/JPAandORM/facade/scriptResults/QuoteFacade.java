package facades;

import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Query;

import entities.Quote;

public class QuoteFacade {

    private EntityManagerFactory emf;

    public QuoteFacade(EntityManagerFactory emf) {
        this.emf = emf;
    }

    EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public Quote addQuote(Quote x) {
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

    public Quote deleteQuote(int id) {
        EntityManager em = getEntityManager();

        Quote quoteToDelete = em.find(Quote.class, id);

        // Use the entity manager  
        try {
            em.getTransaction().begin();
            em.remove(quoteToDelete);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
        return quoteToDelete;
    }

    public Quote getQuote(int id) {

	EntityManager em = getEntityManager();

        Quote quoteToGet = em.find(Quote.class, id);

        return quoteToGet;

    }

    public List<Quote> getQuotes() {
        List<Quote> quotes = null;
        EntityManager em = getEntityManager();
        try {

            // Use the entity manager  
            Query query
                    = em.createQuery("Select x FROM Quote x");
            quotes = query.getResultList();

        } finally {
            em.close();
        }
        return quotes;
    }

    public Quote editQuote(Quote x) {
        EntityManager em = getEntityManager();
        Quote quoteToEdit = em.find(Quote.class, x.getId());

        try {

            em.getTransaction().begin();

            ///// MUST EDIT THESE! 
            quoteToEdit.setEntityAttrib1(x.getEntityAttrib1());
            quoteToEdit.setEntityAttrib2(x.getEntityAttrib2());
            // ...
            quoteToEdit.setEntityAttribN(x.getEntityAttribN());
	    ///// MUST EDIT THESE!

            // and persist 
            em.persist(quoteToEdit);
            em.getTransaction().commit();

        } finally {
            em.close();
        }

        return quoteToEdit;

    }

}

