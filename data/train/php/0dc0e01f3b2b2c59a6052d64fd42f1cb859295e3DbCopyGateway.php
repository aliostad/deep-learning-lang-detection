<?php  namespace App\Gateways;

use App\Models\Copy;

class DbCopyGateway
{
    /**
     * @var \App\Models\Copy
     */
    protected $copy;

    public function __construct(Copy $copy)
    {
        $this->copy = $copy;
    }

    public function newInstance($attributes = [])
    {
        return $this->copy->newInstance($attributes);
    }

    public function create($attributes = [])
    {
        $copy = $this->newInstance($attributes);

        return $copy->save();
    }

    public function all()
    {
        return $this->copy->newQuery()
            ->get();
    }

    public function forSlug($slug)
    {
        return $this->copy->newQuery()
            ->where('slug', '=', $slug)
            ->first();

        return $parent->children;
    }

    public function updateForSlug($slug, $attributes = [])
    {
        $copy = $this->forSlug($slug);

        $copy->fill($attributes);

        return $copy->save();
    }
}
