---
to: <%= rootDirectory %>/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalName %>EntryForm.vue
---
<template>
  <v-card :elevation="0">
    <v-card-title v-if="!isEmbedded"><%= struct.screenLabel || struct.name.pascalName %>{{ isNew ? '追加' : '編集' }}</v-card-title>
    <v-card-text>
      <v-form v-if="syncedTarget" ref="entryForm" class="full-width" lazy-validation>
        <v-layout wrap>
        <%_ entity.editProperties.forEach(function (property, key) { -%>
          <%_ if (property.type === 'string' && property.name === 'id') { -%>
          <v-flex md12 sm12 xs12>
            <v-text-field
              v-model="syncedTarget.<%= property.name %>"
              :disabled="!isNew"
              :rules="validationRules.<%= property.name %>"
              label="<%= property.screenLabel ? property.screenLabel : property.name %>"
              required
            ></v-text-field>
          </v-flex>
          <%_ } -%>
          <%_ if (property.type === 'string' && property.name !== 'id') { -%>
          <v-flex md12 sm12 xs12>
            <v-text-field
              v-model="syncedTarget.<%= property.name %>"
              :rules="validationRules.<%= property.name %>"
              label="<%= property.screenLabel ? property.screenLabel : property.name %>"
            ></v-text-field>
          </v-flex>
          <%_ } -%>
          <%_ if (property.type === 'number' && property.name === 'id') { -%>
          <v-flex md12 sm12 xs12>
            <v-text-field
              :disabled="!isNew"
              :rules="validationRules.<%= property.name %>"
              :value="syncedTarget.<%= property.name %>"
              label="<%= property.screenLabel ? property.screenLabel : property.name %>"
              required
              type="number"
              @input="v => syncedTarget.<%= property.name %> = v === '' ? undefined : Number(v)"
            ></v-text-field>
          </v-flex>
          <%_ } -%>
          <%_ if (property.type === 'number' && property.name !== 'id') { -%>
          <v-flex md12 sm12 xs12>
            <v-text-field
              :rules="validationRules.<%= property.name %>"
              :value="syncedTarget.<%= property.name %>"
              label="<%= property.screenLabel ? property.screenLabel : property.name %>"
              type="number"
              @input="v => syncedTarget.<%= property.name %> = v === '' ? undefined : Number(v)"
            ></v-text-field>
          </v-flex>
          <%_ } -%>
          <%_ if (property.type === 'time') { -%>
          <date-time-form
            :date-time.sync="syncedTarget.<%= property.name %>"
            :rules="validationRules.<%= property.name %>"
            label="<%= property.screenLabel ? property.screenLabel : property.name %>"
          ></date-time-form>
          <%_ } -%>
          <%_ if (property.type === 'textarea') { -%>
          <v-flex md12 sm12 xs12>
            <v-textarea
              v-model="syncedTarget.<%= property.name %>"
              :rules="validationRules.<%= property.name %>"
              label="<%= property.screenLabel ? property.screenLabel : property.name %>"
            ></v-textarea>
          </v-flex>
          <%_ } -%>
          <%_ if (property.type === 'bool') { -%>
          <v-flex md12 sm12 xs12>
            <v-checkbox
              v-model="syncedTarget.<%= property.name %>"
              :rules="validationRules.<%= property.name %>"
              label="<%= property.screenLabel ? property.screenLabel : property.name %>"
            ></v-checkbox>
          </v-flex>
          <%_ } -%>
          <%_ if (property.type === 'image' && property.dataType === 'string') { -%>
          <v-flex xs12>
            <image-form
              :image-url.sync="syncedTarget.<%= property.name %>"
              :rules="validationRules.<%= property.name %>"
              dir="<%= struct.name.lowerCamelName %>/<%= property.name %>"
              label="<%= property.screenLabel ? property.screenLabel : property.name %>"
            ></image-form>
          </v-flex>
          <%_ } -%>
          <%_ if (property.type === 'array-image') { -%>
          <v-flex xs12>
            <image-array-form
              :image-urls.sync="syncedTarget.<%= property.name %>"
              :rules="validationRules.<%= property.name %>"
              dir="<%= struct.name.lowerCamelName %>/<%= property.name %>"
              label="<%= property.screenLabel ? property.screenLabel : property.name %>"
            ></image-array-form>
          </v-flex>
          <%_ } -%>
          <%_ if (property.type === 'array-string' || property.type === 'array-textarea' || property.type === 'array-number' || property.type === 'array-time' || property.type === 'array-bool') { -%>
          <v-flex xs12>
            <expansion label="<%= property.screenLabel ? property.screenLabel : property.name %>一覧">
              <%_ if (property.childType === 'string') { -%>
              <array-form
                v-slot="{editTarget, updatedForm}"
                :items.sync="syncedTarget.<%= property.name %>"
                initial="">
                <v-text-field
                  :rules="validationRules.<%= property.name %>"
                  :value="editTarget"
                  label="<%= property.screenLabel ? property.screenLabel : property.name %>"
                  @input="updatedForm"
                ></v-text-field>
              </array-form>
              <%_ } -%>
              <%_ if (property.childType === 'textarea') { -%>
              <array-form
                v-slot="{editTarget, updatedForm}"
                :items.sync="syncedTarget.<%= property.name %>"
                initial="">
                <v-textarea
                  :rules="validationRules.<%= property.name %>"
                  :value="editTarget"
                  label="<%= property.screenLabel ? property.screenLabel : property.name %>"
                  @input="updatedForm"
                ></v-textarea>
              </array-form>
              <%_ } -%>
              <%_ if (property.childType === 'number') { -%>
              <array-form
                v-slot="{editTarget, updatedForm}"
                :initial="0"
                :items.sync="syncedTarget.<%= property.name %>">
                <v-text-field
                  :rules="validationRules.<%= property.name %>"
                  :value="editTarget"
                  label="<%= property.screenLabel ? property.screenLabel : property.name %>"
                  type="number"
                  @input="v => updatedForm(v === '' ? undefined : Number(v))"
                ></v-text-field>
              </array-form>
              <%_ } -%>
              <%_ if (property.childType === 'bool') { -%>
              <array-form
                v-slot="{editTarget, updatedForm}"
                :initial="false"
                :items.sync="syncedTarget.<%= property.name %>">
                <v-checkbox
                  :rules="validationRules.<%= property.name %>"
                  :value="editTarget"
                  label="<%= property.screenLabel ? property.screenLabel : property.name %>"
                  @change="updatedForm"
                ></v-checkbox>
              </array-form>
              <%_ } -%>
              <%_ if (property.childType === 'time') { -%>
              <array-form
                v-slot="{editTarget, updatedForm}"
                :initial="formatISO(new Date())"
                :items.sync="syncedTarget.<%= property.name %>">
                <date-time-form
                  :date-time.sync="editTarget"
                  :rules="validationRules.<%= property.name %>"
                  label="<%= property.screenLabel ? property.screenLabel : property.name %>"
                  @update:dateTime="updatedForm"
                ></date-time-form>
              </array-form>
              <%_ } -%>
            </expansion>
          </v-flex>
          <%_ } -%>
          <%_ if (property.type === 'array-struct') { -%>
          <v-flex xs12>
            <expansion label="<%= property.screenLabel ? property.screenLabel : property.name %>一覧">
              <struct-array-form
                :initial="initial<%= property.structName.pascalName %>"
                :items.sync="syncedTarget.<%= property.name %>">
                <template v-slot:table="{items, openEntryForm, removeRow}">
                  <<%= property.structName.lowerSnakeName %>-data-table
                    :has-parent="true"
                    :items="items"
                    @openEntryForm="openEntryForm"
                    @remove="removeRow"
                  ></<%= property.structName.lowerSnakeName %>-data-table>
                </template>
                <template v-slot:form="{editIndex, isEntryFormOpen, editTarget, closeForm, removeForm, updatedForm}">
                  <<%= property.structName.lowerSnakeName %>-entry-form
                    :has-parent="true"
                    :is-new="editIndex === NEW_INDEX"
                    :open="isEntryFormOpen"
                    :target="editTarget"
                    @close="closeForm"
                    @remove="removeForm"
                    @updated="updatedForm"
                  ></<%= property.structName.lowerSnakeName %>-entry-form>
                </template>
              </struct-array-form>
            </expansion>
          </v-flex>
          <%_ } -%>
          <%_ if (property.type === 'struct') { -%>
          <v-flex xs12>
            <expansion expanded label="<%= property.screenLabel ? property.screenLabel : property.name %>">
              <<%= property.structName.lowerSnakeName %>-entry-form
                ref="<%= property.name %>Form"
                :has-parent="true"
                :is-embedded="true"
                :target.sync="syncedTarget.<%= property.name %>"
              ></<%= property.structName.lowerSnakeName %>-entry-form>
            </expansion>
          </v-flex>
          <%_ } -%>
        <%_ }) -%>
        </v-layout>
      </v-form>
      <v-layout v-else>
        <v-spacer></v-spacer>
        <v-btn class="action-button" color="primary" dark fab small top @click="initializeTarget">
          <v-icon>mdi-plus</v-icon>
        </v-btn>
      </v-layout>
    </v-card-text>
    <v-card-actions v-if="!isEmbedded">
      <v-btn color="grey darken-1" text @click="close">キャンセル</v-btn>
      <v-spacer></v-spacer>
      <v-btn v-if="!isNew" color="red darken-1" text @click="remove">削除</v-btn>
      <v-spacer></v-spacer>
      <v-btn color="blue darken-1" text @click="save">保存</v-btn>
    </v-card-actions>
  </v-card>
</template>

<script lang="ts">
<%_ let structForms = [] -%>
<%_ entity.editProperties.forEach(function (property, key) { -%>
  <%_ if (property.type === 'struct') { -%>
    <%_ structForms.push(property.name) -%>
  <%_ } -%>
<%_ }) -%>
import {Component, Emit, mixins, Prop, PropSync, <% if (structForms.length > 0) { %>Vue, <% } %>Watch} from 'nuxt-property-decorator'
import {cloneDeep} from 'lodash-es'
import {vxm} from '@/store'
import Base, {VForm} from '@/mixins/base'
import {<%_ if (struct.structType !== 'struct') { -%><%= struct.name.pascalName %>Api, <% } -%>Model<%= struct.name.pascalName %>} from '@/apis'
<%_ let importDateTime = false -%>
<%_ entity.editProperties.forEach(function (property, key) { -%>
  <%_ if ((property.type === 'time' || property.type === 'array-time') && !importDateTime) { -%>
import DateTimeForm from '@/components/form/DateTimeForm.vue'
      <%_ importDateTime = true -%>
  <%_ } -%>
<%_ }) -%>
<%_ if (struct.exists.edit.image) { -%>
import ImageForm from '@/components/form/ImageForm.vue'
<%_ } -%>
<%_ if (struct.exists.edit.arrayImage) { -%>
import ImageArrayForm from '@/components/form/ImageArrayForm.vue'
<%_ } -%>
<%_ const importArrayStructSet = new Set() -%>
<%_ const importStructSet = new Set() -%>
<%_ let importExpansion = false -%>
<%_ let importStructArrayForm = false -%>
<%_ let importArrayForm = false -%>
<%_ entity.editProperties.forEach(function (property, key) { -%>
  <%_ if (property.type === 'array-struct') { -%>
    <%_ if (!importStructArrayForm) { -%>
import StructArrayForm from '@/components/form/StructArrayForm.vue'
      <%_ importStructArrayForm = true -%>
    <%_ } -%>
    <%_ if (!importExpansion) { -%>
import Expansion from '@/components/form/Expansion.vue'
      <%_ importExpansion = true -%>
    <%_ } -%>
    <%_ if (!importArrayStructSet.has(property.structType)) { -%>
import <%= property.structName.pascalName %>EntryForm, {INITIAL_<%= property.structName.upperSnakeName %>} from '@/components/<%= property.structName.lowerCamelName %>/<%= property.structName.pascalName %>EntryForm.vue'
import <%= property.structName.pascalName %>DataTable from '@/components/<%= property.structName.lowerCamelName %>/<%= property.structName.pascalName %>DataTable.vue'
      <%_ importArrayStructSet.add(property.structType) -%>
    <%_ } -%>
  <%_ } -%>
<%_ }) -%>
<%_ entity.editProperties.forEach(function (property, key) { -%>
  <%_ if (property.type === 'struct') { -%>
    <%_ if (!importExpansion) { -%>
import Expansion from '@/components/form/Expansion.vue'
      <%_ importExpansion = true -%>
    <%_ } -%>
    <%_ if (!importArrayStructSet.has(property.structType) && !importStructSet.has(property.structType)) { -%>
import <%= property.structName.pascalName %>EntryForm, {INITIAL_<%= property.structName.upperSnakeName %>} from '@/components/<%= property.structName.lowerCamelName %>/<%= property.structName.pascalName %>EntryForm.vue'
      <%_ importStructSet.add(property.structType) -%>
    <%_ } -%>
  <%_ } -%>
  <%_ if (property.type === 'array-string' || property.type === 'array-textarea' || property.type === 'array-number' || property.type === 'array-time' || property.type === 'array-bool') { -%>
    <%_ if (!importExpansion) { -%>
import Expansion from '@/components/form/Expansion.vue'
      <%_ importExpansion = true -%>
    <%_ } -%>
    <%_ if (!importArrayForm) { -%>
import ArrayForm from '@/components/form/ArrayForm.vue'
      <%_ importArrayForm = true -%>
    <%_ } -%>
  <%_ } -%>
<%_ }) -%>

export const INITIAL_<%= struct.name.upperSnakeName %>: Model<%= struct.name.pascalName %> = {
<%_ entity.editProperties.forEach(function (property, key) { -%>
  <%_ if (property.type === 'struct') { -%>
  <%= property.name %>: INITIAL_<%= property.structName.upperSnakeName %>,
  <%_ } -%>
  <%_ if (property.type.startsWith('array')) { -%>
  <%= property.name %>: [],
  <%_ } -%>
  <%_ if (property.type === 'string' || property.type === 'textarea' || property.type === 'time') { -%>
  <%= property.name %>: undefined,
  <%_ } -%>
  <%_ if (property.type === 'bool') { -%>
  <%= property.name %>: undefined,
  <%_ } -%>
  <%_ if (property.type === 'number') { -%>
  <%= property.name %>: undefined,
  <%_ } -%>
<%_ }) -%>
}

@Component({
  components: {
<%_ if (struct.exists.edit.image) { -%>
    ImageForm,
<%_ } -%>
<%_ if (struct.exists.edit.arrayImage) { -%>
    ImageArrayForm,
<%_ } -%>
<%_ let componentsDateTime = false -%>
<%_ entity.editProperties.forEach(function (property, key) { -%>
  <%_ if ((property.type === 'time' || property.type === 'array-time') && !componentsDateTime) { -%>
    DateTimeForm,
      <%_ componentsDateTime = true -%>
  <%_ } -%>
<%_ }) -%>
<%_ const componentsStructTableSet = new Set() -%>
<%_ const componentsStructFormSet = new Set() -%>
<%_ let componentsExpansion = false -%>
<%_ let componentsStructArrayForm = false -%>
<%_ let componentsArrayForm = false -%>
<%_ entity.editProperties.forEach(function (property, key) { -%>
  <%_ if (property.type === 'struct' && !componentsStructFormSet.has(property.structType)) { -%>
    <%_ if (!componentsExpansion) { -%>
    Expansion,
      <%_ componentsExpansion = true -%>
    <%_ } -%>
    <%_ if (!componentsStructFormSet.has(property.structType)) { -%>
    <%= property.structName.pascalName %>EntryForm,
      <%_ componentsStructFormSet.add(property.structType) -%>
    <%_ } -%>
  <%_ } -%>
  <%_ if (property.type === 'array-struct') { -%>
    <%_ if (!componentsExpansion) { -%>
    Expansion,
      <%_ componentsExpansion = true -%>
    <%_ } -%>
    <%_ if (!componentsStructArrayForm) { -%>
    StructArrayForm,
      <%_ componentsStructArrayForm = true -%>
    <%_ } -%>
    <%_ if (!componentsStructTableSet.has(property.structType)) { -%>
    <%= property.structName.pascalName %>DataTable,
      <%_ componentsStructTableSet.add(property.structType) -%>
    <%_ } -%>
    <%_ if (!componentsStructFormSet.has(property.structType)) { -%>
    <%= property.structName.pascalName %>EntryForm,
      <%_ componentsStructFormSet.add(property.structType) -%>
    <%_ } -%>
  <%_ } -%>
  <%_ if (property.type === 'array-string' || property.type === 'array-textarea' || property.type === 'array-number' || property.type === 'array-time' || property.type === 'array-bool') { -%>
    <%_ if (!componentsExpansion) { -%>
    Expansion,
      <%_ componentsExpansion = true -%>
    <%_ } -%>
    <%_ if (!componentsArrayForm) { -%>
    ArrayForm,
      <%_ componentsArrayForm = true -%>
    <%_ } -%>
  <%_ } -%>
<%_ }) -%>
  }
})
export default class <%= struct.name.pascalName %>EntryForm extends mixins(Base) {
  /** 表示状態 (true: 表示, false: 非表示) */
  @PropSync('open', {type: Boolean, default: true})
  syncedOpen!: boolean

  /** 編集対象 */
  @PropSync('target', {type: Object})
  syncedTarget!: Model<%= struct.name.pascalName %>

  /** 表示方式 (true: 埋め込み, false: ダイアログ) */
  @Prop({type: Boolean, default: false})
  isEmbedded!: boolean

  /** 表示方式 (true: 子要素として表示, false: 親要素として表示) */
  @Prop({type: Boolean, default: false})
  hasParent!: boolean

  /** 編集状態 (true: 新規, false: 更新) */
  @Prop({type: Boolean, default: true})
  isNew!: boolean
<%_ entity.editProperties.forEach(function (property, key) { -%>
  <%_ if (property.type === 'array-struct') { -%>

  /** <%= property.structName.pascalName %>の初期値 */
  initial<%= property.structName.pascalName %> = INITIAL_<%= property.structName.upperSnakeName %>
  <%_ } -%>
<%_ }) -%>

  get validationRules() {
    return {
<%_ entity.editProperties.forEach(function (property, key) { -%>
  <%_ if (property.type !== 'array-struct' && property.type !== 'struct') { -%>
      <%= property.name %>: [],
  <%_ } -%>
<%_ }) -%>
    }
  }

  @Watch('syncedOpen')
  onOpen() {
    if (this.syncedOpen) {
      const dialogElement = document.getElementsByClassName('v-dialog--active')?.[0]
      if (dialogElement) {
        dialogElement.scrollTop = 0
      }
      (this.$refs.entryForm as VForm).resetValidation()<% if (structForms.length > 0) { %>;<% } %>
<%_ structForms.forEach(function (name, index) { -%>
      ((this.$refs.<%= name %>Form as Vue)?.$refs.entryForm as VForm)?.resetValidation()<% if (structForms.length - 1 !== index) { %>;<% } %>
<%_ }) -%>
    }
  }

  initializeTarget() {
    this.syncedTarget = cloneDeep(INITIAL_<%= struct.name.upperSnakeName %>)
  }

  async save() {
<%_ if (structForms.length === 0) { -%>
    if (!(this.$refs.entryForm as VForm).validate()) {
<%_ } else { -%>
    if (!(this.$refs.entryForm as VForm).validate()
<%_ structForms.forEach(function (name, index) { -%>
      || ((this.$refs.<%= name %>Form as Vue)?.$refs.entryForm as VForm)?.validate() === false<% if (structForms.length - 1 === index) { %>) {<% } %>
<%_ }) -%>
<%_ } -%>
      vxm.app.showDialog({
        title: 'エラー',
        message: '入力項目を確認して下さい。'
      })
      return
    }
  <%_ if (struct.structType !== 'struct') { -%><%# Structでない場合 -%>
    if (this.hasParent) {
      // 親要素側で保存
      return
    }
    vxm.app.showLoading()
    try {
      if (this.isNew) {
        // 新規の場合
        await new <%= struct.name.pascalName %>Api().create<%= struct.name.pascalName %>({
          body: this.syncedTarget
        })
      } else {
        // 更新の場合
        await new <%= struct.name.pascalName %>Api().update<%= struct.name.pascalName %>({
          id: this.syncedTarget.id!,
          body: this.syncedTarget
        })
      }
      this.close()
      this.saved()
    } finally {
      vxm.app.hideLoading()
    }
  <%_ } else { -%>
    this.close()
    this.saved()
  <%_ } -%>
  }

  @Emit('updated')
  saved() {
  }

  @Emit('remove')
  async remove() {
    return this.syncedTarget
  }

  @Emit('close')
  close() {
    if (!this.isEmbedded) {
      this.syncedOpen = false
    }
  }
}
</script>

<style scoped>
.action-button {
  pointer-events: auto;
}
</style>
