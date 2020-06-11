
namespace TAO
{
  namespace DCPS
  {
    ACE_INLINE
    DataSampleListElement::DataSampleListElement (
      PublicationId           publication_id,
      TransportSendListener*  send_listner,
      PublicationInstance*    handle,
      TransportSendElementAllocator* allocator)
      : sample_ (0),
        publication_id_ (publication_id), 
        group_id_ (0),
        previous_sample_ (0),
        next_sample_ (0),
        next_instance_sample_ (0),
        next_send_sample_ (0),
        send_listener_ (send_listner),
        space_available_ (false),
        handle_(handle),
        transport_send_element_allocator_(allocator)
    {
    }

    ACE_INLINE
    DataSampleListElement::~DataSampleListElement ()
    {
      if (sample_ != 0)
        {
          sample_->release ();
        }
    }
 
    ACE_INLINE
    DataSampleList::DataSampleList() 
      : head_( 0), 
        tail_( 0), 
        size_( 0) 
    { 
    }

    ACE_INLINE
    void DataSampleList::reset ()
    {
      head_ = tail_ = 0;
      size_ = 0;
    }

    ACE_INLINE
    void
    DataSampleList::enqueue_tail_next_sample (DataSampleListElement* sample)
    {
      sample->previous_sample_ = 0;
      sample->next_sample_ = 0;
      
      ++size_ ;
      if( head_ == 0) 
        {
          // First sample in the list.
          head_ = tail_ = sample ;
        } 
      else 
        {
          // Add to existing list.
          tail_->next_sample_ = sample ;
          sample->previous_sample_ = tail_;
          tail_ = sample;
        }    
    }

    ACE_INLINE
    bool
    DataSampleList::dequeue_head_next_sample (DataSampleListElement*& stale)
    {
      //
      // Remove the oldest sample from the list.
      //
      stale = head_;

      if (head_ == 0)
        {
          return false;
        }
      else
        {
          --size_ ;
          head_ = head_->next_sample_;

          if (head_ == 0)
            {
              tail_ = 0;
            }
          else 
            {
              head_->previous_sample_ = 0;
            }

          return true;
        }
    }

    ACE_INLINE
    void
    DataSampleList::enqueue_tail_next_send_sample (DataSampleListElement* sample)
    {
      sample->previous_sample_ = 0;
      sample->next_sample_ = 0;
      sample->next_send_sample_ = 0;

      ++ size_ ;
      if(head_ == 0) 
        {
          // First sample in list.
          head_ = tail_ = sample ;
        } 
      else 
        {
          // Add to existing list.
          sample->previous_sample_ = tail_;
          tail_->next_sample_ = sample;
          tail_->next_send_sample_ = sample ;
          tail_ = sample ;
        }
    }

    ACE_INLINE
    bool
    DataSampleList::dequeue_head_next_send_sample (DataSampleListElement*& stale)
    {
      //
      // Remove the oldest sample from the instance list.
      //
      stale = head_;

      if (head_ == 0)
        {
          return false;
        }
      else
        {
          --size_ ;
          head_ = head_->next_send_sample_ ;
          if (head_ == 0)
            {
              tail_ = 0;
            }
          else 
            {
              head_->previous_sample_ = 0;
            }
          return true;
        }
    }

    ACE_INLINE
    void
    DataSampleList::enqueue_tail_next_instance_sample (DataSampleListElement* sample)
    {
      sample->next_instance_sample_ = 0;

      ++ size_ ;
      if(head_ == 0) 
        {
          // First sample on queue.
          head_ = tail_ = sample ;
        } 
      else 
        {
          // Another sample on an existing queue.
          tail_->next_instance_sample_ = sample ;
          tail_ = sample ;
        }
    }

    ACE_INLINE
    bool
    DataSampleList::dequeue_head_next_instance_sample (DataSampleListElement*& stale)
    {
      //
      // Remove the oldest sample from the instance list.
      //
      stale = head_;

      if (head_ == 0)
        { 
          // try to dequeue empty instance list.
          return false;
        }
      else 
        {
          --size_ ;
          head_ = head_->next_instance_sample_ ;
          if (head_ == 0)
            {
              tail_ = 0;
            }
          return true;
        }
    }

  }  /* namespace DCPS */
}  /* namespace TAO */

