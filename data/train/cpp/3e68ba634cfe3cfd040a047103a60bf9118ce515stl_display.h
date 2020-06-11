
template <typename T>
std::ostream& operator<<(std::ostream& stream, const std::list<T>& list)
{
    stream << "[";
    bool first = true;
    for (const T& item : list)
    {
        if (!first)
            stream << ", ";
        else
            first = false;
        stream << item;
    }
    stream << "]";
    return stream;
}

template <typename T>
std::ostream& operator<<(std::ostream& stream, const std::set<T>& list)
{
    stream << "{";
    bool first = true;
    for (const T& item : list)
    {
        if (!first)
            stream << ", ";
        else
            first = false;
        stream << item;
    }
    stream << "}";
    return stream;
}

