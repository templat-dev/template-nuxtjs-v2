---
to: <%= rootDirectory %>/initials/<%= struct.name.pascalName %>Initials.ts
---
import {Writable} from 'type-fest'
import {Model<%= struct.name.pascalName %>, <%= struct.name.pascalName %>ApiSearch<%= struct.name.pascalName %>Request} from '~/apis'
<%_ const searchConditions = [] -%>
<%_ if (struct.fields && struct.fields.length > 0) { -%>
<%_ struct.fields.forEach(function (field, key) { -%>
  <%_ if ((field.listType === 'string' || field.listType === 'array-string' || field.listType === 'time' || field.listType === 'array-time') && field.searchType === 1) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelName, type: 'string', range: false}) -%>
  <%_ } -%>
  <%_ if ((field.listType === 'bool' || field.listType === 'array-bool') && field.searchType === 1) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelName, type: 'boolean', range: false}) -%>
  <%_ } -%>
  <%_ if ((field.listType === 'number' || field.listType === 'array-number') && field.searchType === 1) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelName, type: 'number', range: false}) -%>
  <%_ } -%>
  <%_ if ((field.listType === 'number' || field.listType === 'array-number') && 2 <= field.searchType &&  field.searchType <= 5) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelName, type: 'number', range: true}) -%>
  <%_ } -%>
  <%_ if ((field.listType === 'time' || field.listType === 'array-time') && 2 <= field.searchType &&  field.searchType <= 5) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelName, type: 'string', range: true}) -%>
  <%_ } -%>
<%_ }) -%>
<%_ } -%>

export const INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION: Writable<<%= struct.name.pascalName %>ApiSearch<%= struct.name.pascalName %>Request> = {
  <%_ searchConditions.forEach(function(searchCondition) { -%>
    <%_ if (searchCondition.type === 'string' && !searchCondition.range) { -%>
  <%= searchCondition.name %>: undefined,
    <%_ } -%>
    <%_ if (searchCondition.type === 'boolean' && !searchCondition.range) { -%>
  <%= searchCondition.name %>: undefined,
    <%_ } -%>
    <%_ if (searchCondition.type === 'number' && !searchCondition.range) { -%>
  <%= searchCondition.name %>: undefined,
    <%_ } -%>
    <%_ if (searchCondition.type === 'number' && searchCondition.range) { -%>
  <%= searchCondition.name %>: undefined,
  <%= searchCondition.name %>From: undefined,
  <%= searchCondition.name %>To: undefined,
    <%_ } -%>
    <%_ if (searchCondition.type === 'string' && searchCondition.range) { -%>
  <%= searchCondition.name %>: undefined,
  <%= searchCondition.name %>From: undefined,
  <%= searchCondition.name %>To: undefined,
    <%_ } -%>
  <%_ }) -%>
}

export const INITIAL_<%= struct.name.upperSnakeName %>: Model<%= struct.name.pascalName %> = {
<%_ struct.fields.forEach(function (field, key) { -%>
  <%_ if (field.editType === 'struct') { -%>
  <%= field.name.lowerCamelName %>: INITIAL_<%= field.structName.upperSnakeName %>,
  <%_ } -%>
  <%_ if (field.editType.startsWith('array')) { -%>
  <%= field.name.lowerCamelName %>: [],
  <%_ } -%>
  <%_ if (field.editType === 'string' || field.editType === 'textarea' || field.editType === 'time') { -%>
  <%= field.name.lowerCamelName %>: undefined,
  <%_ } -%>
  <%_ if (field.editType === 'bool') { -%>
  <%= field.name.lowerCamelName %>: undefined,
  <%_ } -%>
  <%_ if (field.editType === 'number') { -%>
  <%= field.name.lowerCamelName %>: undefined,
  <%_ } -%>
<%_ }) -%>
}
