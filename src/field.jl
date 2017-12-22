"""
Table Schema field
https://github.com/frictionlessdata/tableschema-jl#field
"""

mutable struct Field
    descriptor::Dict
    name::String
    typed::String
    format::String
    constraints::Constraints
    # required::Bool

    function Field(d::Dict)
        name = haskey(d, "name") ? d["name"] : ""
        typed = haskey(d, "type") ? d["type"] : DEFAULT_TYPE
        format = haskey(d, "format") ? d["format"] : DEFAULT_FORMAT
        constraints = haskey(d, "constraints") ?
            Constraints(d["constraints"]) : Constraints()
        # required = cons.required
        new(d, name, typed, format, constraints)
    end

    Field(name::String) = Field(Dict( "name" => name ))
end

# cast_value = NullException()
# test_value = NullException()

checkrow(f::Field, val, col::Array=[]) = checkrow(f.constraints, val, col)

type FieldError <: Exception
    message::String
    # key::String
    # line::Int16
end

function validate(f::Field)
    if isempty(f.descriptor)
        throw(FieldError("Missing Descriptor"))
    elseif f.descriptor.name == ""
        throw(FieldError("Name is empty"))
    elseif f.descriptor.typed == ""
        throw(FieldError("Type is empty"))
    end
end
