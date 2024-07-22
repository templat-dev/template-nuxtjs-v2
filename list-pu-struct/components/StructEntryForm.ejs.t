---
to: <%= rootDirectory %>/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalName %>EntryForm.vue
---
<template>
  <v-card :elevation="0">
    <v-card-title v-if="!isEmbedded"><%= struct.screenLabel || struct.name.pascalName %>{{ isNew ? '追加' : '編集' }}</v-card-title>
    <v-card-text>
      <v-form v-if="syncedTarget" ref="entryForm" class="full-width" lazy-validation>
        <v-layout wrap>
        <%_ struct.fields.forEach(function (field, key) { -%>
          <%_ if (field.editType === 'string' && field.name.lowerCamelName === 'id') { -%>
          <v-flex md12 sm12 xs12>
            <v-text-field
              v-model="syncedTarget.<%= field.name.lowerCamelName %>"
              :disabled="!isNew"
              :rules="validationRules.<%= field.name.lowerCamelName %>"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
              required
            ></v-text-field>
          </v-flex>
          <%_ } -%>
          <%_ if (field.editType === 'string' && field.name.lowerCamelName !== 'id') { -%>
          <v-flex md12 sm12 xs12>
            <v-text-field
              v-model="syncedTarget.<%= field.name.lowerCamelName %>"
              :rules="validationRules.<%= field.name.lowerCamelName %>"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
            ></v-text-field>
          </v-flex>
          <%_ } -%>
          <%_ if (field.editType === 'number' && field.name.lowerCamelName === 'id') { -%>
          <v-flex md12 sm12 xs12>
            <v-text-field
              :disabled="!isNew"
              :rules="validationRules.<%= field.name.lowerCamelName %>"
              :value="syncedTarget.<%= field.name.lowerCamelName %>"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
              required
              type="number"
              @input="v => syncedTarget.<%= field.name.lowerCamelName %> = v === '' ? undefined : Number(v)"
            ></v-text-field>
          </v-flex>
          <%_ } -%>
          <%_ if (field.editType === 'number' && field.name.lowerCamelName !== 'id') { -%>
          <v-flex md12 sm12 xs12>
            <v-text-field
              :rules="validationRules.<%= field.name.lowerCamelName %>"
              :value="syncedTarget.<%= field.name.lowerCamelName %>"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
              type="number"
              @input="v => syncedTarget.<%= field.name.lowerCamelName %> = v === '' ? undefined : Number(v)"
            ></v-text-field>
          </v-flex>
          <%_ } -%>
          <%_ if (field.editType === 'time') { -%>
          <date-time-form
            :date-time.sync="syncedTarget.<%= field.name.lowerCamelName %>"
            :rules="validationRules.<%= field.name.lowerCamelName %>"
            label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
          ></date-time-form>
          <%_ } -%>
          <%_ if (field.editType === 'textarea') { -%>
          <v-flex md12 sm12 xs12>
            <v-textarea
              v-model="syncedTarget.<%= field.name.lowerCamelName %>"
              :rules="validationRules.<%= field.name.lowerCamelName %>"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
            ></v-textarea>
          </v-flex>
          <%_ } -%>
          <%_ if (field.editType === 'bool') { -%>
          <v-flex md12 sm12 xs12>
            <v-checkbox
              v-model="syncedTarget.<%= field.name.lowerCamelName %>"
              :rules="validationRules.<%= field.name.lowerCamelName %>"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
            ></v-checkbox>
          </v-flex>
          <%_ } -%>
          <%_ if (field.editType === 'image' && field.dataType === 'string') { -%>
          <v-flex xs12>
            <image-form
              :image-url.sync="syncedTarget.<%= field.name.lowerCamelName %>"
              :rules="validationRules.<%= field.name.lowerCamelName %>"
              dir="<%= struct.name.lowerCamelName %>/<%= field.name.lowerCamelName %>"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
            ></image-form>
          </v-flex>
          <%_ } -%>
          <%_ if (field.editType === 'array-image') { -%>
          <v-flex xs12>
            <image-array-form
              :image-urls.sync="syncedTarget.<%= field.name.lowerCamelName %>"
              :rules="validationRules.<%= field.name.lowerCamelName %>"
              dir="<%= struct.name.lowerCamelName %>/<%= field.name.lowerCamelName %>"
              label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
            ></image-array-form>
          </v-flex>
          <%_ } -%>
          <%_ if (field.editType === 'array-string' || field.editType === 'array-textarea' || field.editType === 'array-number' || field.editType === 'array-time' || field.editType === 'array-bool') { -%>
          <v-flex xs12>
            <expansion label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>一覧">
              <%_ if (field.childType === 'string') { -%>
              <array-form
                v-slot="{editTarget, updatedForm}"
                :items.sync="syncedTarget.<%= field.name.lowerCamelName %>"
                initial="">
                <v-text-field
                  :rules="validationRules.<%= field.name.lowerCamelName %>"
                  :value="editTarget"
                  label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
                  @input="updatedForm"
                ></v-text-field>
              </array-form>
              <%_ } -%>
              <%_ if (field.childType === 'textarea') { -%>
              <array-form
                v-slot="{editTarget, updatedForm}"
                :items.sync="syncedTarget.<%= field.name.lowerCamelName %>"
                initial="">
                <v-textarea
                  :rules="validationRules.<%= field.name.lowerCamelName %>"
                  :value="editTarget"
                  label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
                  @input="updatedForm"
                ></v-textarea>
              </array-form>
              <%_ } -%>
              <%_ if (field.childType === 'number') { -%>
              <array-form
                v-slot="{editTarget, updatedForm}"
                :initial="0"
                :items.sync="syncedTarget.<%= field.name.lowerCamelName %>">
                <v-text-field
                  :rules="validationRules.<%= field.name.lowerCamelName %>"
                  :value="editTarget"
                  label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
                  type="number"
                  @input="v => updatedForm(v === '' ? undefined : Number(v))"
                ></v-text-field>
              </array-form>
              <%_ } -%>
              <%_ if (field.childType === 'bool') { -%>
              <array-form
                v-slot="{editTarget, updatedForm}"
                :initial="false"
                :items.sync="syncedTarget.<%= field.name.lowerCamelName %>">
                <v-checkbox
                  :rules="validationRules.<%= field.name.lowerCamelName %>"
                  :value="editTarget"
                  label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
                  @change="updatedForm"
                ></v-checkbox>
              </array-form>
              <%_ } -%>
              <%_ if (field.childType === 'time') { -%>
              <array-form
                v-slot="{editTarget, updatedForm}"
                :initial="formatISO(new Date())"
                :items.sync="syncedTarget.<%= field.name.lowerCamelName %>">
                <date-time-form
                  :date-time.sync="editTarget"
                  :rules="validationRules.<%= field.name.lowerCamelName %>"
                  label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
                  @update:dateTime="updatedForm"
                ></date-time-form>
              </array-form>
              <%_ } -%>
            </expansion>
          </v-flex>
          <%_ } -%>
          <%_ if (field.editType === 'array-struct') { -%>
          <v-flex xs12>
            <expansion label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>一覧">
              <struct-array-form
                :initial="initial<%= field.structName.pascalName %>"
                :items.sync="syncedTarget.<%= field.name.lowerCamelName %>">
                <template v-slot:table="{items, openEntryForm, removeRow}">
                  <<%= field.structName.pascalName %>DataTable
                    :has-parent="true"
                    :items="items"
                    @openEntryForm="openEntryForm"
                    @remove="removeRow"
                  ></<%= field.structName.pascalName %>DataTable>
                </template>
                <template v-slot:form="{editIndex, isEntryFormOpen, editTarget, closeForm, removeForm, updatedForm}">
                  <<%= field.structName.pascalName %>EntryForm
                    :has-parent="true"
                    :is-new="editIndex === NEW_INDEX"
                    :open="isEntryFormOpen"
                    :target="editTarget"
                    @close="closeForm"
                    @remove="removeForm"
                    @updated="updatedForm"
                  ></<%= field.structName.pascalName %>EntryForm>
                </template>
              </struct-array-form>
            </expansion>
          </v-flex>
          <%_ } -%>
          <%_ if (field.editType === 'struct') { -%>
          <v-flex xs12>
            <expansion expanded label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>">
              <<%= field.structName.pascalName %>EntryForm
                ref="<%= field.name.lowerCamelName %>Form"
                :has-parent="true"
                :is-embedded="true"
                :target.sync="syncedTarget.<%= field.name.lowerCamelName %>"
              ></<%= field.structName.pascalName %>EntryForm>
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
import {Component, Emit, mixins, Prop, PropSync, <% if (struct.exists.edit.struct) { %>Vue, <% } %>Watch} from 'nuxt-property-decorator'
import {cloneDeep} from 'lodash-es'
import {vxm} from '@/store'
import Base, {VForm} from '@/mixins/base'
import {<%_ if (struct.structType !== 'struct') { -%><%= struct.name.pascalName %>Api, <% } -%>Model<%= struct.name.pascalName %>} from '@/apis'
<%_ if (struct.exists.edit.time || struct.exists.edit.arrayTime) { -%>
import DateTimeForm from '@/components/form/DateTimeForm.vue'
<%_ } -%>
<%_ if (struct.exists.edit.image) { -%>
import ImageForm from '@/components/form/ImageForm.vue'
<%_ } -%>
<%_ if (struct.exists.edit.arrayImage) { -%>
import ImageArrayForm from '@/components/form/ImageArrayForm.vue'
<%_ } -%>
<%_ if (struct.exists.edit.struct || struct.exists.edit.arrayNumber || struct.exists.edit.arrayText || struct.exists.edit.arrayTextArea || struct.exists.edit.arrayBool || struct.exists.edit.arrayTime || struct.exists.edit.arrayStruct) { -%>
import Expansion from '@/components/form/Expansion.vue'
<%_ } -%>
<%_ if (struct.exists.edit.arrayNumber || struct.exists.edit.arrayText || struct.exists.edit.arrayTextArea || struct.exists.edit.arrayBool || struct.exists.edit.arrayTime) { -%>
import ArrayForm from '@/components/form/ArrayForm.vue'
<%_ } -%>
<%_ if (struct.exists.edit.arrayStruct) { -%>
import StructArrayForm from '@/components/form/StructArrayForm.vue'
<%_ } -%>
<%_ const importStructTableSet = new Set() -%>
<%_ const importStructFormSet = new Set() -%>
<%_ struct.fields.forEach(function (field, key) { -%>
  <%_ if (field.editType === 'array-struct') { -%>
    <%_ if (!importStructTableSet.has(field.structName.pascalName)) { -%>
import <%= field.structName.pascalName %>DataTable from '@/components/<%= field.structName.lowerCamelName %>/<%= field.structName.pascalName %>DataTable.vue'
      <%_ importStructTableSet.add(field.structName.pascalName) -%>
    <%_ } -%>
    <%_ if (!importStructFormSet.has(field.structName.pascalName)) { -%>
import <%= field.structName.pascalName %>EntryForm, {INITIAL_<%= field.structName.upperSnakeName %>} from '@/components/<%= field.structName.lowerCamelName %>/<%= field.structName.pascalName %>EntryForm.vue'
      <%_ importStructFormSet.add(field.structName.pascalName) -%>
    <%_ } -%>
  <%_ } -%>
  <%_ if (field.editType === 'struct') { -%>
    <%_ if (!importStructFormSet.has(field.structName.pascalName)) { -%>
import <%= field.structName.pascalName %>EntryForm, {INITIAL_<%= field.structName.upperSnakeName %>} from '@/components/<%= field.structName.lowerCamelName %>/<%= field.structName.pascalName %>EntryForm.vue'
      <%_ importStructFormSet.add(field.structName.pascalName) -%>
    <%_ } -%>
  <%_ } -%>
<%_ }) -%>

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

@Component({
  components: {
<%_ if (struct.exists.edit.time || struct.exists.edit.arrayTime) { -%>
    DateTimeForm,
<%_ } -%>
<%_ if (struct.exists.edit.image) { -%>
    ImageForm,
<%_ } -%>
<%_ if (struct.exists.edit.arrayImage) { -%>
    ImageArrayForm,
<%_ } -%>
<%_ if (struct.exists.edit.struct || struct.exists.edit.arrayNumber || struct.exists.edit.arrayText || struct.exists.edit.arrayTextArea || struct.exists.edit.arrayBool || struct.exists.edit.arrayTime || struct.exists.edit.arrayStruct) { -%>
    Expansion,
<%_ } -%>
<%_ if (struct.exists.edit.arrayNumber || struct.exists.edit.arrayText || struct.exists.edit.arrayTextArea || struct.exists.edit.arrayBool || struct.exists.edit.arrayTime) { -%>
    ArrayForm,
<%_ } -%>
<%_ if (struct.exists.edit.arrayStruct) { -%>
    StructArrayForm,
<%_ } -%>
<%_ const componentsStructTableSet = new Set() -%>
<%_ const componentsStructFormSet = new Set() -%>
<%_ struct.fields.forEach(function (field, key) { -%>
  <%_ if (field.editType === 'array-struct') { -%>
    <%_ if (!componentsStructTableSet.has(field.structName.pascalName)) { -%>
    <%= field.structName.pascalName %>DataTable,
      <%_ componentsStructTableSet.add(field.structName.pascalName) -%>
    <%_ } -%>
    <%_ if (!componentsStructFormSet.has(field.structName.pascalName)) { -%>
    <%= field.structName.pascalName %>EntryForm,
      <%_ componentsStructFormSet.add(field.structName.pascalName) -%>
    <%_ } -%>
  <%_ } -%>
  <%_ if (field.editType === 'struct') { -%>
    <%_ if (!componentsStructFormSet.has(field.structName.pascalName)) { -%>
    <%= field.structName.pascalName %>EntryForm,
      <%_ componentsStructFormSet.add(field.structName.pascalName) -%>
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

<%_ if (struct.structType !== 'struct') { -%><%# Structでない場合 -%>
  /** 編集状態 (true: 新規, false: 更新) */
  @Prop({type: Boolean, default: true})
  isNew!: boolean
<%_ } else { -%>
  get isNew() {
    return !this.syncedTarget.id
  }
<%_ } -%>
<%_ struct.fields.forEach(function (field, key) { -%>
  <%_ if (field.editType === 'array-struct') { -%>

  /** <%= field.structName.pascalName %>の初期値 */
  initial<%= field.structName.pascalName %> = INITIAL_<%= field.structName.upperSnakeName %>
  <%_ } -%>
<%_ }) -%>

  get validationRules() {
    return {
<%_ struct.fields.forEach(function (field, key) { -%>
  <%_ if (field.editType !== 'array-struct' && field.editType !== 'struct') { -%>
      <%= field.name.lowerCamelName %>: [],
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
      (this.$refs.entryForm as VForm).resetValidation()
<%_ struct.fields.forEach(function (field, key) { -%>
  <%_ if (field.editType === 'struct') { -%>
      ;((this.$refs.<%= field.name.lowerCamelName %>Form as Vue)?.$refs.entryForm as VForm)?.resetValidation()
  <%_ } -%>
<%_ }) -%>
    }
  }

  initializeTarget() {
    this.syncedTarget = cloneDeep(INITIAL_<%= struct.name.upperSnakeName %>)
  }

  async save() {
<%_ if (!struct.exists.edit.struct) { -%>
    if (!(this.$refs.entryForm as VForm).validate()) {
<%_ } else { -%>
    if (!(this.$refs.entryForm as VForm).validate()
<%_ struct.fields.forEach(function (field, key) { -%>
  <%_ if (field.editType === 'struct') { -%>
      || ((this.$refs.<%= field.name.lowerCamelName %>Form as Vue)?.$refs.entryForm as VForm)?.validate() === false
  <%_ } -%>
<%_ }) -%>
    ) {
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
  saved() {}

  @Emit('remove')
  async remove() {}

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
