
<?php foreach ($copies as $copy) : ?>
 /**
 * @param boolean $deepCopy Whether to also copy all rows that refer (by fkey) to the current row.
 * @return <?php echo $objectClass ?> Clone of current object but with null if the field is not visible for '<?php echo $copy['visibilityLabel'] ?>'
 * @throws PropelException
 */
public function <?php echo $copy['methodName'] ?>($deepCopy = false)
{
    $copy = $this->copy();

    <?php foreach ($copy['isVisibleMethods'] as $field => $method) : ?>if (!$copy-><?php echo $method ?>()) {
        $copy-><?php echo $copy['fieldsSetter'][$field] ?>(null);
    }
    
    <?php endforeach; ?>

    return $copy;
}

<?php endforeach; ?>